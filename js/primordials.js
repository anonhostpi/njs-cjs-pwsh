InternalObject => {
    const primordials = { __proto__: null };

    [
        // Configurable value properties of the global object
        'Proxy',
        'globalThis'
    ].forEach( name => primordials[name] = globalThis[name] )

    [
        // URI functions
        decodeURI,
        decodeURIComponent,
        encodeURI,
        encodeURIComponent,
        
        // Legacy functions
        escape,
        eval,
        unescape
    ].forEach( fn => primordials[fn.name] = fn )

    [
        // Namespace objects
        'Atomics',
        'JSON',
        'Math',
        'Reflect'
    ].forEach( name => {
        primordials[name] = {}
        InternalObject.flattener.flatten( primordials[name], globalThis[name], true )
    })

    [
        // Intrinsic objects
        'AggregateError',
        'Array',
        'ArrayBuffer',
        'BigInt',
        'BigInt64Array',
        'BigUint64Array',
        'Boolean',
        'DataView',
        'Date',
        'Error',
        'EvalError',
        'FinalizationRegistry',
        'Float32Array',
        'Float64Array',
        'Function',
        'Int8Array',
        'Int16Array',
        'Int32Array',
        'Map',
        'Number',
        'Object',
        'RangeError',
        'ReferenceError',
        'RegExp',
        'Set',
        'String',
        'Symbol',
        'SyntaxError',
        'TypeError',
        'URIError',
        'Uint8Array',
        'Uint8ClampedArray',
        'Uint16Array',
        'Uint32Array',
        'WeakMap',
        'WeakRef',
        'WeakSet'
    ].foreach( name => {
        let intrinsic = globalThis[name];
        primordials[name] = { original: intrinsic }

        InternalObject.flattener.flatten( primordials[name], intrinsic, true );
        InternalObject.flattener.protoflatten( primordials[name], intrinsic, true );
    })

    primordials.Symbol.Dispose ??= primordials.Symbol.For('nodejs.dispose')
    primordials.Symbol.AsyncDispose ??= primordials.Symbol.For('nodejs.asyncdispose')

    [
        // Intrinsic objects that require a valid 'this' to call static methods
        'Promise'
    ].forEach( name => {
        let intrinsic = globalThis[name];
        primordials[name] = { original: intrinsic }

        InternalObject.flattener.flatten( primordials[name], intrinsic, false );
        InternalObject.flattener.protoflatten( primordials[name], intrinsic, true );
    })

    [
        // Intrinsic objects that are not exposed to the global object
        { name: "TypedArray", intrinsic: primordials.Reflect.GetPrototypeOf( Uint8Array ) },
        { name: "ArrayIterator", intrinsic: {
            prototype: primordials.Reflect.GetPrototypeOf( Array.prototype[Symbol.iterator]() )
        }},
        { name: "StringIterator", intrinsic: {
            prototype: primordials.Reflect.GetPrototypeOf( String.prototype[Symbol.iterator]() )
        }}
    ].forEach(({ name, intrinsic }) => {
        primordials[name] = {
            original: intrinsic
        }
        
        InternalObject.flattener.protoflatten( primordials[name], intrinsic, true );
        InternalObject.flattener.protoflatten( primordials[name].proto.constructor, intrinsic.prototype, true );
    })

    const createSafeIterator = ( factory, next )=>{
        class SafeIterator {
            constructor( iterable ){
                this._iterator = factory( iterable );
            }
            next(){
                return next( this._iterator );
            }
            [Symbol.Iterator](){
                return this;
            }
        }
        InternalObject.freeze( SafeIterator.prototype );
        return InternalObject.freeze( SafeIterator );
    }

    primordials.SafeIterators = {
        Array: createSafeIterator(
            primordials.Array.proto.constructor.SymbolIterator,
            primordials.ArrayIterator.proto.constructor.next),
        String: createSafeIterator(
            primordials.String.proto.constructor.SymbolIterator,
            primordials.StringIterator.proto.constructor.next)
    }

    return new InternalObject(primordials);
}