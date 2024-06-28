const CDP = require('chrome-remote-interface');
const { spawn } = require('child_process');

class NodeDumper {
    #args;
    constructor ( path = __dirname + "/dump.js", host, port ) {

        this.path = path;
        this.host = host;
        this.port = port;

        const inspect = "--inspect";
        if(
            ( host != null && host.toString().trim() != '' ) ||
            ( port != null && port.toString().trim() != '' )
        ){
            inspect += "=";
            if( host == null || host.toString().trim() == '' )
                inspect += "port"
            else {
                inspect += host;
                if( port != null && port.toString().trim() != '' )
                    inspect += `:${port}`
            }
        }

        const self = this

        this.#args = [ '--expose-internals', '-r', '"internal/test/binding"', inspect ]
        if( path != null && path.toString().trim() != '' )
            this.#args.push( path );
    }
    #job = async ( mainResolve ) => {
        this.ended = new Promise((endResolve, reject) => {
            this.process.on('close', (code, sig) => {
                if( code == null )
                    code = 0; 
                endResolve();
                console.warn(`Node.js process exited with code ${code} via signal ${sig}`);
            });
        })

        this.process.stdout.on('data', (data) => {  
            console.log(`stdout: ${data}`);
        });

        this.client = await CDP({ port: 9229 });
        const { Debugger } = this.client;
        Debugger.enable()

        let lastParsedScripts = 0;

        const checkCompletion = () => {
            if (Object.keys(this.dump).length === lastParsedScripts) {
                console.warn('Dump complete');
                mainResolve(this.dump);
            } else {
                lastParsedScripts = Object.keys(this.dump).length;
                setTimeout(checkCompletion, 1000); // Check every second
            }
        };

        Debugger.on('scriptParsed', async (params) => {
            console.log( params.scriptId, params.url )
            const { scriptSource: source } = await Debugger.getScriptSource({ scriptId: params.scriptId })
            this.dump[params.scriptId] = {
                metadata: params,
                source
            }
        })

        setTimeout(checkCompletion, 1000);
    }

    start(){
        console.warn('Spawning node!')
        this.process = spawn('node', this.#args);

        return new Promise( mainResolve => {

            const awaitStart = data => {
    
                if( data.toString().startsWith('Debugger listening') ){
                    console.warn(`stderr: ${data}`);
                    this.process.stderr.on('data', data =>{
                        if( data.toString().startsWith('Debugger attached') )
                            console.warn(`stderr: ${data}`);
                        else if( data.toString().startsWith('Debugger ending') )
                            console.warn(`stderr: ${data}`);
                        else if( data.toString().startsWith('For help') )
                            console.warn(`stderr: ${data}`);
                        else
                            console.error(`stderr: ${data}`)
                    });
                    this.#job( mainResolve );
                } else {
                    console.error(`stderr: ${data}`);
                    this.process.stderr.once('data', awaitStart);
                }
            }

            this.process.stderr.once('data', awaitStart);
        });
    }

    async close(){
        console.warn('Closing dumper')
        await this.client.close();
        this.process.kill( 'SIGINT' );
        await this.ended;
    }

    ended;

    client;
    process;

    dump = {};
}

(async ()=>{

    const dumper = new NodeDumper();
    await dumper.start();
    await dumper.close();
    
    let out = JSON.stringify( dumper.dump, null, 2 )
    // write to file:
    const fs = require('fs');
    fs.writeFileSync('dump.json', out);
    process.exit()

})();