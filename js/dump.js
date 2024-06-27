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

Object.getOwnPropertyNames(globalThis).forEach(name => { console.log( name )})