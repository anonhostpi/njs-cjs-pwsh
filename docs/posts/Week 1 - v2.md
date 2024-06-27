Prior posts from this mini-series:

* Thanos Shauntlet: [https://www.reddit.com/r/PowerShell/comments/199i7nr/now\_presenting\_the\_thanos\_shauntlet/](https://www.reddit.com/r/PowerShell/comments/199i7nr/now_presenting_the_thanos_shauntlet/)
* Turning PowerShell Into A Python Engine: [https://www.reddit.com/r/PowerShell/comments/192uavr/turning\_powershell\_into\_a\_python\_engine/](https://www.reddit.com/r/PowerShell/comments/192uavr/turning_powershell_into_a_python_engine/)
* Turning PowerShell Into A JavaScript Engine: [https://www.reddit.com/r/PowerShell/comments/1937hkv/turning\_powershell\_into\_a\_javascript\_engine/](https://www.reddit.com/r/PowerShell/comments/1937hkv/turning_powershell_into_a_javascript_engine/)
* Working On Turning PowerShell Into A Node.JS Engine: [https://www.reddit.com/r/PowerShell/comments/1djdql5/working_on_turning_powershell_into_a_nodejs_engine/](https://www.reddit.com/r/PowerShell/comments/1djdql5/working_on_turning_powershell_into_a_nodejs_engine/)
  * **TL;DR: [_Github gist_](https://gist.github.com/anonhostpi/7ebc4007f3f51e0f255c2408d33b1781)**

# TL;DR:

```powershell
git clone https://github.com/anonhostpi/njs-cjs-pwsh
cd njs-cjs-pwsh
cd pwsh
. .\main.ps1

# $runtime
# $engine
# $tests
```

# Week 1: More Source Code Analysis

So last week I decided I wanted to setup on replicating the Node.JS `vm` module. However, I've discovered I need to dig a little deeper into API replication, because the `vm` module references a lot of internal objects and methods.

## Node's 2 hidden objects

Primarily, the 2 problem-causers are Node.JS's hidden `primordials` and `internalBinding()` objects. These objects are reused frequently throughout the entire Node.JS codebase. `primordials` is a collection of objects that are used to prevent prototype pollution and object tampering in their codebase. `internalBindings()` is function to bind native objects and methods to js objects.

`internalBindings()` is going to have to be something that I completely redo from the ground up, since ClearScript uses C# host objects instead of native/C++ objects. `primordials` is defined via pure ECMAScript, so it's easier to replicate. So, this last week, I've been giving a lot of attention to `primordials`.

## Replication

At first, I thought I would just replicate it using the typescript specification and the js source file, and I've been spending a lot of time on that:
- [Github - nodejs/node - typings/primorials.d.ts](https://github.com/nodejs/node/blob/2eff28fb7a93d3f672f80b582f664a7c701569fb/typings/primordials.d.ts)
- [Github - nodejs/node - lib/internal/per_context/primordials.js](https://github.com/nodejs/node/blob/53ac448022b7cdfcc09296da88d9a1b59921f6bf/lib/internal/per_context/primordials.js)

However, I've discovered after skimming some of the node.js source code, that I may not need to replicate it.

In fact, there may be several files that don't need to be replicated at all. There are several files, including primordials.js, that don't reference `internalBinding()` at all. There is the possibility of native code being shipped to a module with no calls to that function via `require()`, but all I have to do is filter out any files that reference either function.

## The Plan

So, we need to add some more tests to last weeks source code analysis script. Firstly, we need to attack 3 key areas:
- files that reference `internalBinding()`
- files that reference `require()`
- files that reference neither

An additional thing we need to do, that we didn't do last week, is ensure that we are analyzing all builtin modules when doing this. We can do that by calling this:

```js
// ensure all builtin modules are loaded
require("module").builtinModules.forEach( mod => {
    // check if globalThis already contains key mod
    if( globalThis[mod] === undefined ){
        // if not, add it
        globalThis[mod] = require(mod);
    } else {
        // if it does, find another name
        let i = 1;
        while( globalThis[`${mod}_${i}`] !== undefined )
            i++;
        globalThis[`${mod}_${i}`] = require(mod);
    }
})

// for comparing node's globalThis to ClearScript's globalThis
Object.getOwnPropertyNames(globalThis).forEach(name => { console.log( name )})
```

We will put this in a file called dump.js

### Dumping with Devtools Protocol

We've already covered dumping the `globalThis` object in my last post. Today, we need a method for dumping the source tree. We can do this by using the npm package `chrome-remote-interface`. This package allows us to interact with the Chrome Devtools Protocol. We will also use the `child_process` module to spawn dump.js as a child process.

```js
const CDP = require('chrome-remote-interface');
const { spawn } = require('child_process');
```

Now let's setup a class to handle dumping. First, we need to setup the constructor to construct the arguments array to be sent to the child node process:

```js
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

        this.#args = [ '--expose-internals', inspect ]
        if( path != null && path.toString().trim() != '' )
            this.#args.push( path );
    }

    // ...
}
```

Next, we need to setup a method to spawn the child process and wait for it to finish opening the debugging port. We'll do this with promisification, and we'll pass the resolver to the dumper's main method `#job()`:

```js
class NodeDumper {
    // ...

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

                    console.warn('Starting dumper!')
                    this.#job( mainResolve );

                } else {
                    console.error(`stderr: ${data}`);
                    this.process.stderr.once('data', awaitStart);
                }
            }

            this.process.stderr.once('data', awaitStart);
        });
    }

    // ...
}
```

Now, we need to setup `#job()`. This method will control the lifecycle of the dumper. It will connect to the Chrome Devtools Protocol, dump the source tree, and then close the connection and the child process:

First, we need to ensure that both the connection and the child process will close when the dumper is done:

```js
class NodeDumper {
    
    // ...

    ended; // will be a promise

    async close(){
        console.warn('Closing dumper')
        await this.client.close();
        this.process.kill( 'SIGINT' );
        await this.ended;
    }
    
    #job( mainResolve ){
        this.ended = new Promise((endResolve, reject) => {
            this.process.on('close', (code, sig) => {
                if( code == null )
                    code = 0; 
                endResolve();
                console.warn(`Node.js process exited with code ${code} via signal ${sig}`);
            });
        })

        // ...

    }

    // ...

}
```

We can also pipe stdout, if preferred:

```js
class NodeDumper {
    // ...
    #job( startResolve ){

        // ...
        
        this.process.stdout.on('data', (data) => {  
            console.log(`stdout: ${data}`);
        });

        // ...
        
    }
    // ...
}
```

Then, we connect to the Chrome Devtools Protocol:

```js
class NodeDumper {
    
    // ...
    
    client;
    
    #job( startResolve ){

        // ...
        
        this.client = await CDP({ port: 9229 });
        const { Debugger } = this.client;
        Debugger.enable()

        // ...
    }
    // ...
}
```

Now, we get to the fun part. Dumping the source tree:


```js
class NodeDumper {

    // ...

    dump = {};

    #job( startResolve ){
        // ...

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

        // ...
    }
    // ...
}
```

Now that the class is complete, we can use it to dump the source tree:

```js
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
```

### dump.json Analysis

Now that we have the dump, we can go back to PowerShell and analyze it:

```powershell
$result = node ./dumper.js
$dump = [PSCustomObject]@{
    Log = $result
    Source = Get-Content .\dump.json -Raw | ConvertFrom-Json -AsHashtable
}
```

To analyze the source tree, we need some helper functions:

```powershell
$dump | Add-Member `
    -Name Search `
    -MemberType ScriptMethod `
    -Value {
        param( $search )

        $search = [regex]::Escape($search)
        $search = "(?<!\/\/.*)$search" 

        $this.Source.GetEnumerator() | ForEach-Object {
            $scriptId = $_.Key
            $script = $_.Value.source
            $metadata = $_.Value.metadata

            $lines = New-Object System.Collections.ArrayList

            # Find the search term, and return the metadata, and the line number

            $script -split '\r?\n' | ForEach-Object -Begin { $line = 0 } {
                $line++

                if ($_ -match $search) {
                    $lineObj = [PSCustomObject]@{
                        Line = $line
                        Text = $_
                    }

                    $lineObj | Add-Member -MemberType ScriptMethod -Name ToString -Value {
                        $this.Line.ToString()
                    } -Force
                    $lines.Add($lineObj) | Out-Null
                }
            }

            if( $lines.Count -eq 0 ){
                return
            }

            [PSCustomObject]@{
                Id = $scriptId
                Name = $metadata.url
                Count = $lines.Count
                Lines = $lines
                Metadata = $metadata
            }
        }

        return $out
    }

$dump | Add-Member `
    -Name Exclude `
    -MemberType ScriptMethod `
    -Value {
        param( $searches )

        $this.Source.GetEnumerator() | ForEach-Object {
            $scriptId = $_.Key
            $script = $_.Value.source
            $metadata = $_.Value.metadata

            # Exclude all files that containe any of the search terms

            $matches = $script -split '\r?\n' | ForEach-Object {
                $line = $_

                $searches | ForEach-Object {
                    $search = [regex]::Escape($_)
                    $search = "(?<!\/\/.*)$search"

                    $line -match $search
                }
            } | Where-Object { $_ }
            
            If( $matches.Count -eq 0 ){
                [PSCustomObject]@{
                    Id = $scriptId
                    Name = $metadata.url
                    Metadata = $metadata
                }
            }
        }
    }
```

Revisiting, our criteria:
> We need to attack 3 key areas:
> - files that reference `internalBinding()`

```powershell
$dump.Search('internalBinding')
```

> - files that reference `require()`

```powershell
$dump.Search('require')
```

> - files that reference neither

```powershell
$dump.Exclude('internalBinding','require')
```

#### Results:

- `internalBinding`:
  - 121 files
- `require`:
  - 206 files
- `neither`:
  - 16 files, including `primordials.js`

## Conclusion and Next Steps

So, we've discovered that I don't need to replicate `primordials.js`. We've also discovered that there are 15 other files that possibly don't need to be replicated either.

Next week, we will be testing the 16 files that don't reference `internalBinding()` or `require()`. It is important to note that nearly all node's internal files reference `primordials`, so we will need to ensure that object is replicated first and provisioned to all files that need it.

I'm uploading this project as a git repository, so that it can be followed:
- [Github - anonhostpi/njs-cjs-pwsh](https://github.com/anonhostpi/njs-cjs-pwsh)