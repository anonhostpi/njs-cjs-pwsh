**TL;DR: _WIP_**

Prior posts from this mini-series:

* Thanos Shauntlet: [https://www.reddit.com/r/PowerShell/comments/199i7nr/now\_presenting\_the\_thanos\_shauntlet/](https://www.reddit.com/r/PowerShell/comments/199i7nr/now_presenting_the_thanos_shauntlet/)
* Turning PowerShell Into A Python Engine: [https://www.reddit.com/r/PowerShell/comments/192uavr/turning\_powershell\_into\_a\_python\_engine/](https://www.reddit.com/r/PowerShell/comments/192uavr/turning_powershell_into_a_python_engine/)
* Turning PowerShell Into A JavaScript Engine: [https://www.reddit.com/r/PowerShell/comments/1937hkv/turning\_powershell\_into\_a\_javascript\_engine/](https://www.reddit.com/r/PowerShell/comments/1937hkv/turning_powershell_into_a_javascript_engine/)
* Working On Turning PowerShell Into A Node.JS Engine: [https://www.reddit.com/r/PowerShell/comments/1djdql5/working_on_turning_powershell_into_a_nodejs_engine/](https://www.reddit.com/r/PowerShell/comments/1djdql5/working_on_turning_powershell_into_a_nodejs_engine/)
  * **TL;DR: [_Github gist_](https://gist.github.com/anonhostpi/7ebc4007f3f51e0f255c2408d33b1781)**

# Week 1: Primordial Soup

So last week I decided I wanted to setup on replicating the Node.JS `vm` module. However, I've discovered I need to dig a little deeper into API replication, because the `vm` module references a lot of internal objects and methods.

The 2 problem-causers are Node.JS's `primordials` and `internalBinding()`

`internalBindings()` is going to have to be something that I completely redo from the ground up, since ClearScript uses C# host objects instead of native/C++ objects.

`primordials` on the other hand is a bit easier to replicate, because it has typescript type definition file for it:
- [Github - nodejs/node - typings/primordials.d.ts](https://github.com/nodejs/node/blob/2eff28fb7a93d3f672f80b582f664a7c701569fb/typings/primordials.d.ts)

Node's `primordials` serves 2 purposes: it presents certain types in a way that is easily interfaceable with C++, and it also provides a way to prevent prototype pollution and object tampering in their codebase.

For example, `ArrayPrototypeForEach` is a wrapper for `Array.prototype.forEach` that can't be affected by prototype pollution:

```js
let originalForEach = Array.prototype.forEach;
let ArrayPrototypeForEach = function( self, callback, thisArg ) {
    return originalForEach.call( self, callback, thisArg );
}

Array.prototype.forEach = function() {
    throw new Error( "Nope!" );
}

let arr = [1, 2, 3];

ArrayPrototypeForEach( arr, ( value, index ) => {
    console.log( value, index );
}); // This will work
arr.forEach( ( value, index ) => {
    console.log( value, index );
}); // This will throw an error
```

Now, I'd like to replicate this, but I have a different idea for doing.

## Reimplementing `primordials` using OOP via Object.freeze()

One of the benefits about using PowerShell/C# as a backend for ClearScript, is that I'm not limited to the interfacing issues posed by C++. Specifically, I can share objects between the host and the engine instead of just functions and primitives.

Another thing I want to do is provide an API for preventing prototype pollution and object tampering for any object I want. To do this, we need to write an API for deep-freezing objects and removing their prototypes.

### The Deep Freezer:

```js
class InternalObject {
    static Seal = Object.seal; // for convenience
    static Freeze = function( target ) {
        target.__proto__ = null;
        Object.getOwnPropertyNames(target).forEach(name => {
            const prop = target[name];
            if ( typeof prop === 'object' && !Object.isSealed(prop) ) {
                // we skip sealed objects in additon to frozen objects to selectively allow for object tampering
                InternalObject.Freeze(prop);
            }
        });
        return Object.freeze(target);
    }
    constructor(target){
        console.log(this)
        let freeze = InternalObject.Freeze;
        if( typeof target === 'function' ){
            self = target;
        } else {
            self = this;
            Object.assign(self, target);
        }
        return freeze(self);
    }
    static Create = function( target ){
        return new InternalObject( target );
    }
}

InternalObject.Freeze(InternalObject);
```

This class provides a way to deep-freeze objects and remove their prototypes.

Now a problem with this class is that sometimes, you do want to inherit a property from a prototype. So I've added a static method to selectively apply prototype properties to the object:

```js
class InternalObject {
    static ApplyPrototype = function( target, props ){
        if( typeof props === 'string' )
            props = [props];
        if( Array.isArray(props) ){
            props = props.map( prop =>{
                return `${prop}`
            })
        } else {
            props = [];
        }
        
        let descriptors = {};

        if( props.length > 0 ){
            props.forEach( prop => {
                if( !Object.prototype.hasOwnProperty.call( target, prop ) ){
                    let descriptor = Object.getOwnPropertyDescriptor( target.__proto__, prop );
                    if( descriptor ){
                        descriptors[prop] = descriptor;
                    }
                }
            })
        } else {
            descriptors = Object.getOwnPropertyDescriptors( target.__proto__ )
        }
        for( let key in descriptors ){
            if( !Object.prototype.hasOwnProperty.call( target, key ) ){
                Object.defineProperty( target, key, descriptors[key] )
            }
        }
        return target;
    }
}
```

If the second argument is omitted, all prototype properties are propagated to the object. The second argument can be a string or an array of strings, which are the names of the properties to propagate.

### Exposing the Deep Freezer

Now I don't want to completely expose this class, and I also want to advise against over-using it. The problem with this class is its a one and done deal. Once InternalObject.Freeze is called, the entire object tree is frozen, _and has its prototypes removed_.

This is dangerous because if a value in the object tree was set to a primitive or a V8 built-in object, its prototype would be lost.

So instead of defining this object in the global scope, we can wrap it in an expression and return it to the PowerShell host to isolate it:

```powershell
$internals = @{}
$internals.InternalObject = @{}
$internals.InternalObject.src = @"
(() => {

    // Be careful with this class! It is a deep freeze class and it destroys the prototype chain.
    // It's purpose is to prevent:
    // - prototype pollution
    // - modification to internals
    
    // DO NOT USE IT LIGHTLY.
    // DO NOT FREEZE OR CAST V8 BUILT-IN OBJECTS TO THIS CLASS.
    // USE IT ONLY TO FINALIZE AN INTERNAL OBJECT.

    class InternalObject {

        // ... class definition here ...

    }

    InternalObject.Freeze(InternalObject);

    return InternalObject;
})()
"@
$internals.InternalObject.value = $engine.Evaluate($internals.InternalObject.src)
```

### Using the Deep Freezer

So since the class isn't exposed to the global scope, we can't use it directly. Instead, we have to pass it to a function from the engine to use it.

Example:

```powershell
$func = $engine.Evaluate("InternalObject => new InternalObject({ a: 1, b: 2, c: 3})")
$result = $func.call($null, $internals.InternalObject.value)

$func2 = $engine.Evaluate("InternalObject => InternalObject.ApplyPrototype")
$func3 = $func2.call($null, $internals.InternalObject.value)
$result2 = $func3.call($null, $result, "toString")

$result2.toString()
```

### Porting `primordials`

Now that we have a way to protect internal objects, we can start porting `primordials` to PowerShell.

