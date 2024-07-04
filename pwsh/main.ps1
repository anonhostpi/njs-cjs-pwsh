# Install-Module Import-Package
# Install-Module New-ThreadController

Write-Host "Preparing Test Environment:"
Write-Host "  - Imports:"
Write-Host "    - Import-Package: " -NoNewline

Try {
    Import-Module "Import-Package"
    Write-Host "       " -NoNewline
    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host " ";
} Catch {
    Write-Host "       " -NoNewline
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host " ";
    throw $_
    Pause
}

Write-Host "    - New-ThreadController: " -NoNewline

Try {
    Import-Module "New-ThreadController"
    Write-Host " " -NoNewline
    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host " ";
} Catch {
    Write-Host " " -NoNewline
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host " ";
    throw $_
    Pause
}
Write-Host "    - Microsoft.ClearScript: " -NoNewline

Try {
    Import-Package "Microsoft.ClearScript" -ErrorAction Stop
    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host " ";
} Catch {
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "  - Threads:"

$threads = @{
    "loadcallback" = & {
        Write-Host "    - LoadCallback:" -NoNewline

        Try {
            $shared = [hashtable]::Synchronized(@{
                "DocumentQueue" = [System.Collections.Concurrent.ConcurrentQueue[Microsoft.ClearScript.DocumentInfo]]::new()
            })
            $thread = New-ThreadController -Name "LoadCallback" -SessionProxies @{
                "Shared" = $shared
            }
            $thread | Add-Member `
                -Name "Shared" `
                -MemberType NoteProperty `
                -Value $shared
            $thread
            Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
        } Catch {
            Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
            throw $_
            Pause
        }
    } 
}

Write-Host "  - Types:"

$csharp = @{
    "loadcallback" = @{
        "source" = @"
using System;
using System.Collections;
using System.Collections.Concurrent;
using System.Windows.Threading;
using Microsoft.ClearScript;
using System.Linq;
using System.Reflection;
using System.Threading.Tasks;

public class LoadCallback
{
    public static object Runtime { get; set; }
    public static Action Callback { get; set; }
    public static Hashtable Shared { get; set; }

    public static void Run( ref Microsoft.ClearScript.DocumentInfo documentInfo )
    {
        ConcurrentQueue<Microsoft.ClearScript.DocumentInfo> q = (ConcurrentQueue<Microsoft.ClearScript.DocumentInfo>) Shared["DocumentQueue"];
        q.Enqueue( documentInfo );
        if (Runtime is System.Windows.Threading.Dispatcher wpfDispatcher)
        {
            wpfDispatcher.InvokeAsync(Callback).Task.GetAwaiter().GetResult();
        }
        else
        {
            var dispatcherType = Runtime.GetType();
            var method = dispatcherType.GetMethod("InvokeAsync", new Type[] { typeof(Action) });

            if (method != null)
            {
                var task = (Task) method.Invoke(Runtime, new object[] { Callback });
                task.GetAwaiter().GetResult();
            }
            else
            {
                throw new InvalidOperationException("Dispatcher must have an InvokeAsync method.");
            }
        }
    }
}
"@
        "Assemblies" = @(
            & {
                $assembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_ -like "*WindowsBase*" }
                $assembly.Location
            }
            "ClearScript.Core"
            "System.Collections.Concurrent"
            "Microsoft.CSharp"
            "System.Linq"
            "System.Console"
        )
        "Trailing" = @{
            "IgnoreWarnings" = $true
        }
    }
}

Write-Host "    - LoadCallback: " -NoNewline

Try {
    $trailing = $csharp.loadcallback.trailing
    $csharp.loadcallback = Add-Type `
        -TypeDefinition $csharp.loadcallback.source `
        -ReferencedAssemblies $csharp.loadcallback.assemblies `
        -PassThru `
        -ErrorAction Stop `
        @trailing
    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "  - Configuration:"
Write-Host "    - LoadCallback:" -NoNewline

Try {
    $csharp.loadcallback::Runtime = $threads.loadcallback.Dispatcher
    $csharp.loadcallback::Shared = $threads.loadcallback.Shared
    $csharp.loadcallback::Callback = [System.Action] {
        [Microsoft.ClearScript.DocumentInfo] $DocumentInfo = [Microsoft.ClearScript.DocumentInfo]::new("");
        $count = 0
        While( $Shared.DocumentQueue.TryDequeue( [ref] $DocumentInfo ) ){
            Write-Host "Loading document: $($DocumentInfo.Name)"
            $count++
        }
        If( $count ){
            $Shared.LastDocument = $DocumentInfo
        }
    }.Ast.GetScriptBlock()

    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "    - ClearScript:" -NoNewline

$options = @{
    "port" = 9222
    "runtime" = [Enum]::Parse(
        [Microsoft.ClearScript.V8.V8RuntimeFlags],
        @(
            # "None"
            "EnableDebugging"
            # "EnableRemoteDebugging"
            "EnableDynamicModuleImports"
        ) -join ", "   
    )
    "engine" = [Enum]::Parse(
        [Microsoft.ClearScript.V8.V8ScriptEngineFlags],
        @(
            "EnableDebugging"
            # "DisableGlobalMembers"
            # "EnableRemoteDebugging"
            # "AwaitDebuggerAndPauseOnStart"
            # "EnableDateTimeConversion"
            # "EnableDynamicModuleImports"
            # "MarshalUnsafeLongAsBigInt"
            # "MarshalAllLongAsBigInt"
            "EnableTaskPromiseConversion"
            # "EnableValueTaskPromiseConversion"
            # "UseCaseInsensitiveMemberBinding"
            # "EnableStringifyEnhancements"
            # "HideHostExceptions"
            # "AddSynchronizationContexts"
            "AddPerformanceObject"
            # "SetTimerResolution"
        ) -join ", "
    )
    "document" = [Enum]::Parse(
        [Microsoft.ClearScript.DocumentAccessFlags],
        @(
            # "None"
            "EnableFileLoading"
            # "EnableWebLoading"
            # "EnableAllLoading"
            "EnforceRelativePrefix"
            "AllowCategoryMismatch"
            # "UseAsyncLoadCallback"
        ) -join ", "
    )
}

Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
Write-Host "  - Initialization:"
Write-Host "    - Runtime:" -NoNewline

Try {
    $runtime = [Microsoft.ClearScript.V8.V8Runtime]::new( $options.runtime, $options.port )

    $runtime.DocumentSettings.AccessFlags = $options.document
    $runtime.DocumentSettings.SearchPath = $pwd
    $runtime.DocumentSettings.LoadCallback = [Microsoft.ClearScript.DocumentLoadCallback][LoadCallback]::Run

    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause
}

Write-Host "    - Engine:" -NoNewline

Try {

    # $engine = [Microsoft.ClearScript.V8.V8ScriptEngine]::new( $options.engine, 9223 )
    # $engine.DocumentSettings.AccessFlags = $options.document
    # $engine.DocumentSettings.SearchPath = $pwd
    # $engine.DocumentSettings.LoadCallback = [Microsoft.ClearScript.DocumentLoadCallback][LoadCallback]::Run

    $engine = $runtime.CreateScriptEngine( $options.engine )
    $engine.DocumentSettings.AccessFlags = $runtime.DocumentSettings.AccessFlags
    $engine.DocumentSettings.SearchPath = $runtime.DocumentSettings.SearchPath
    $engine.DocumentSettings.LoadCallback = $runtime.DocumentSettings.LoadCallback
    $engine.AllowReflection = $true

    Write-Host "Done" -BackgroundColor Green -NoNewline; Write-Host;
} Catch {
    Write-Host "Failed" -BackgroundColor Red -NoNewline; Write-Host;
    throw $_
    Pause

}

Write-Host "    - Descriptors:" -NoNewline

$descriptors = @{
    "es6" = New-Object Microsoft.ClearScript.DocumentInfo -Property @{
        "Category" = [Microsoft.ClearScript.JavaScript.ModuleCategory]::Standard
    } -ArgumentList "[PowerShell ES6-Module eval]"
    "commonjs" = New-Object Microsoft.ClearScript.DocumentInfo -Property @{
        "Category" = [Microsoft.ClearScript.JavaScript.ModuleCategory]::CommonJS
    } -ArgumentList "[PowerShell CommonJS-Module eval]"
    "script" = New-Object Microsoft.ClearScript.DocumentInfo -Property @{
        "Category" = [Microsoft.ClearScript.DocumentCategory]::Script
    } -ArgumentList "[PowerShell Script eval]"
    "json" = New-Object Microsoft.ClearScript.DocumentInfo -Property @{
        "Category" = [Microsoft.ClearScript.DocumentCategory]::JSON
    } -ArgumentList "[PowerShell JSON eval]"
}

Write-Host "Done" -BackgroundColor Green -NoNewline;

Write-Host
Write-Host "Tests: " -NoNewline; Write-Host "Initialized" -NoNewline -ForegroundColor Green; Write-Host;
Pause;

$paths = @{
    "root" = $PSScriptRoot
    "js" = Resolve-Path ($PSScriptRoot + "\..\js")
}

# $engine.Evaluate( $descriptors.es6, "Object.getOwnPropertyNames(host)" )
# $engine.Evaluate( "globalThis.testing = {}" )
# $engine.Evaluate( "globalThis.testing.this = {}" )
# $engine.Evaluate( "globalThis.testing.this.base = this" )
# $engine.Evaluate( $descriptors.es6, "globalThis.testing.this.es6 = this" )
# $engine.Evaluate( $descriptors.commonjs, "globalThis.testing.this.commonjs = this" )
# $engine.Evaluate( $descriptors.script, "globalThis.testing.this.script = this" )
# $engine.Evaluate( "globalThis.testing.globalThis = {}")
# $engine.Evaluate( "globalThis.testing.globalThis.base = globalThis" )
# $engine.Evaluate( $descriptors.es6, "globalThis.testing.globalThis.es6 = globalThis" )
# $engine.Evaluate( $descriptors.commonjs, "globalThis.testing.globalThis.commonjs = globalThis" )
# $engine.Evaluate( $descriptors.script, "globalThis.testing.globalThis.script = globalThis" )

$tests = @{}

Write-Host "- Diff: "
$tests.diff = & (Join-Path $paths.root "tests\apis.ps1" )
Write-Host "- Import: "
$tests.import = & (Join-Path $paths.root "tests\import.ps1" )
Write-Host "- Dumper: "
$tests.dumper = & (Join-Path $paths.root "tests\dump.ps1" )
Write-Host "- Dump Analysis: "
$tests.analysis = @{}
$tests.analysis.initial = $tests.dumper.calls
Write-Host "  - Detailed: " -NoNewline;
$tests.analysis.detailed = @{}
$tests.analysis.detailed.internalBinding = $tests.dumper.dump.Search( "internalBinding\(\s*([^)\s]*)\s*\)", $false ) # internalBinding only has 2 signatures

$temp = @{}
$temp_md = @"
# All InternalBinding Calls:
"@
$tests.analysis.detailed.internalBinding | ForEach-Object {
    $temp["$($_.Name)"] = $_.Lines

    $temp_md += @"


## $($_.Name) (x$($_.Lines.Count)):
"@
    $_.Lines | ForEach-Object {
        $temp_md += @"

- Line $( $_.Line ): ``$( $_.Text )``
"@
    }
}
$temp | ConvertTo-Json -Depth 4 | Out-File (Join-Path $paths.root "analysis\internalBinding.json")
$temp_md | Out-File (Join-Path $paths.root "analysis\internalBinding.auto.md")

$byBinding = @{}
$tests.analysis.detailed.internalBinding | ForEach-Object {
    $script_name = $_.Name
    $_.Lines | ForEach-Object {
        $line = $_
        $_.Matches.GetEnumerator() | Where-Object { $_.Key -ne "0" } | ForEach-Object {
            $binding = $_.Value
            If( -not $byBinding.ContainsKey( $binding ) ){
                $byBinding["$binding"] = @()
            }
            $byBinding["$binding"] += @{
                "Script" = $script_name
                "Line" = $line.Line
                "Text" = $line.Text
            }
        }
    }
}
$byBinding | ConvertTo-Json -Depth 4 | Out-File (Join-Path $paths.root "analysis\internalBindingByBinding.json")

$byBinding_md = @"
# All InternalBinding Calls by Binding:
"@
$byBinding.GetEnumerator() | ForEach-Object {
    $byBinding_md += @"


## $($_.Key) (x$($_.Value.Count)):
"@
    $_.Value | ForEach-Object {
        $byBinding_md += @"

- $($_.Script):$($_.Line): ``$($_.Text)``
"@
    }
}
$byBinding_md | Out-File (Join-Path $paths.root "analysis\internalBindingByBinding.auto.md")

# $tests.analysis.detailed.require # may require more in-depth analysis due to the various internal require signatures
Write-Host "Done" -ForegroundColor Green -NoNewline; Write-Host