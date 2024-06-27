$engine.AddHostObject("host", [Microsoft.ClearScript.ExtendedHostFunctions]::new() )

$apis = @{
    "node" = & {
        While( $true ){
            Try {
                node (Join-Path $paths.js "dump.js").toString()
                break;
            } Catch {}
        }
    }
    "base" = $engine.Evaluate("Object.getOwnPropertyNames(globalThis)")
}

$diff = Compare-Object $apis.node $apis.base

@{
    "node" = $apis.node
    "base" = $apis.base
    "result" = $diff
}