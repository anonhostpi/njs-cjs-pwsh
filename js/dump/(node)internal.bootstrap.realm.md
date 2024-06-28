compileFunction is a fancy require-like function that searches the global_source_map, compiles the found source, then wraps the source in:

```js
with( null ){ function( ...args ){ } }
```

Where args is specified by this function:
- https://github.com/nodejs/node/blob/895fcb05462268a56ac1e51ce00dc2ecbbbfd438/src/node_builtins.cc#L376

It's a fancy wrapper for this:
- https://v8.github.io/api/head/classv8_1_1ScriptCompiler.html#a3a15bb5a7dfc3f998e6ac789e6b4646a

ClearScript reimplementation:

```powershell
function Invoke-CompileFunction {
  param( 
    [Microsoft.ClearScript.V8.V8ScriptEngine] $engine,
    [System.Collections.IDictionary] $script_with,
    [string] $script_body,
    [string] $script_argnames
  )
  $wrapper = @"
(( $( script_with.Keys[0] ) )->{
    with( $( script_with.Keys[0] ) ) {
        return function(
            $( $script_argnames -join ", " )
        ){
            $script_body
        }
    }
})
"@

    $engine.Evaluate( $wrapper )( $script_with.Values[0] )

}
```

It appears that linked bindings are NAPI bindings compiled specifically for node.js. While it might be theoretically possible to link these bindings to ClearScript, it would arguably be a fruitless effort. It would be way easier to port said NAPI bindings to Powershell/C# than trying to link them to ClearScript.

So, any references to process._linkedBinding() and getLinkedBinding() should be ignored.

There maybe a registerBinding function to register this kind of module, but I'm not clear on it yet.