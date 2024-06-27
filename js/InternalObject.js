(() => {

    // Be careful with this class! It is a deep freeze class and it destroys the prototype chain.
    // It's purpose is to prevent:
    // - prototype pollution
    // - modification to internals
    
    // DO NOT USE IT LIGHTLY.
    // DO NOT FREEZE OR CAST V8 BUILT-IN OBJECTS TO THIS CLASS.
    // USE IT ONLY TO FINALIZE AN INTERNAL OBJECT.

    const {
        defineProperty: ReflectDefineProperty,
        getOwnPropertyDescriptor: ReflectGetOwnPropertyDescriptor,
        ownKeys: ReflectOwnKeys,
    } = Reflect;

    const { apply, bind, call } = Function.prototype;

    const {
        hasOwnProperty: ObjectHasOwnProperty
    } = Object.prototype;
    const { 
        getOwnPropertyDescriptors: ObjectGetOwnPropertyDescriptors,
        seal: ObjectSeal,
        getOwnPropertyNames: ObjectGetOwnPropertyNames,
        isFrozen: ObjectIsFrozen,
        assign: ObjectAssign,
        freeze: ObjectFreeze
    } = Object;


    function rectifyKey ( key ){
        return typeof key === 'symbol' ?
            `Symbol${key.description[7].toUpperCase()}${key.description.slice(8)}` :
            `${key[0].toUpperCase()}${key.slice(1)}`;
    }

    class InternalObject {
        static uncurry = new InternalObject({
            call: bind.bind(call),
            apply: bind.bind(apply)
        });
        static flattener = new InternalObject({
            accessor: function( destination, key, { enumerable, get, set } ){
                key = rectifyKey( key );
                let define = ReflectDefineProperty.bind( null, destination );
                define(
                    `${key}Get`,
                    {
                        __proto__ : null,
                        value: InternalObject.uncurry.call(get),
                        enumerable
                    }
                )
                if( set !== undefined ){
                    define(
                        `${key}Set`,
                        {
                            __proto__ : null,
                            value: InternalObject.uncurry.call(set),
                            enumerable
                        }
                    )
                }
                return destination;
            },
            flatten: function( destination = { __proto__ : null }, target, uncurried = true ){
                let define = ReflectDefineProperty.bind( null, destination );
                for( const key of ReflectOwnKeys( target ) ){
                    let rectified = rectifyKey( key );
                    let desc = ReflectGetOwnPropertyDescriptor( target, key);
                    if( 'get' in desc || 'set' in desc ){
                        InternalObject.flattener.accessor(
                            destination,
                            rectified,
                            desc
                        );
                    } else {
                        const { value } = desc;
                        if( typeof value === 'function' ){
                            desc.value =
                                uncurried ?
                                    InternalObject.uncurry.call( value ) :
                                    value.bind( target );
                            define( `${rectified}Apply`, {
                                __proto__ : null,
                                value: InternalObject.uncurry.apply( value )
                            });
                        }
                        define( rectified, {
                            __proto__ : null,
                            ...desc
                        });
                    }
                }
                return destination;
            },
            protoflatten: function( destination = { __proto__ : null }, target, constructor = true ){
                destination.proto = { __proto__ : null };
                if( constructor ){
                    destination.proto.constructor = { __proto__ : null };
                    InternalObject.flattener.flatten( destination.proto.constructor, target.prototype, true );
                } else {
                    destination.proto.instance = { __proto__ : null };
                    InternalObject.flattener.flatten( destination.proto.instance, target.__proto__, true );
                }
            }
        });
        static applier = new InternalObject({
            proto: function( target, props ){
                return InternalObject.applier.copy( target, target.__proto__, props, false );
            },
            copy: function( target, source, props, proto = false ){
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
                        if( !ObjectHasOwnProperty( target, prop ) ){
                            let descriptor;
                            if( !ObjectHasOwnProperty( source, prop ) && proto )
                                descriptor = ReflectGetOwnPropertyDescriptor( source.__proto__, prop );
                            else
                                descriptor = ReflectGetOwnPropertyDescriptor( source, prop );

                            if( descriptor ){
                                descriptors[prop] = descriptor;
                            }
                        }
                    })
                } else {
                    descriptors = ObjectGetOwnPropertyDescriptors( source )
                }
                for( let key in descriptors ){
                    if( !ObjectHasOwnProperty( target, key ) ){
                        ReflectDefineProperty( target, key, descriptors[key] )
                    }
                }
            }
        })
        static seal = ObjectSeal;
        static freeze = function( target ) {
            target.__proto__ = null;
            ObjectGetOwnPropertyNames(target).forEach(key => {
                const prop = target[key];
                if ( !ObjectIsFrozen(prop) ) {
                    InternalObject.freeze(prop);
                }
            });
            return ObjectFreeze(target);
        }
        constructor(target){
            let freeze = InternalObject.freeze;
            if( typeof target === 'function' ){
                self = target;
            } else {
                self = this;
                ObjectAssign(self, target);
            }
            return freeze(self);
        }
        static Create = function( target ){
            return new InternalObject( target );
        }
    }

    InternalObject.freeze(InternalObject.prototype);
    InternalObject.freeze(InternalObject);

    return InternalObject;
})()