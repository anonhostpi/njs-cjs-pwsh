**TL;DR: _[~comment~](https://www.reddit.com/r/PowerShell/comments/1djdql5/comment/l9a2ri5/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button)_**

Prior posts from this mini-series:

* Thanos Shauntlet: [https://www.reddit.com/r/PowerShell/comments/199i7nr/now\_presenting\_the\_thanos\_shauntlet/](https://www.reddit.com/r/PowerShell/comments/199i7nr/now_presenting_the_thanos_shauntlet/)
* Turning PowerShell Into A Python Engine: [https://www.reddit.com/r/PowerShell/comments/192uavr/turning\_powershell\_into\_a\_python\_engine/](https://www.reddit.com/r/PowerShell/comments/192uavr/turning_powershell_into_a_python_engine/)
* Turning PowerShell Into A JavaScript Engine: [https://www.reddit.com/r/PowerShell/comments/1937hkv/turning\_powershell\_into\_a\_javascript\_engine/](https://www.reddit.com/r/PowerShell/comments/1937hkv/turning_powershell_into_a_javascript_engine/)

# Revisiting Turning PowerShell Into A JS Engine

I know its been a while, and I said I was going to stop, but I've changed my mind...

I've been having fun with embedded Python in PowerShell. Being able to use Python libraries, variables, and objects directly in PowerShell has been a godsend. While I do love PowerShell, Python's libraries are just so much more maintained.

I have been comtemplating doing the same thing with JavaScript, but I have a problem. The embeddings library for JS (ClearScript) lacks a module management system like the one Node.JS has. It's also a pure ECMAScript engine, so it lacks Node.JS-specific APIs like `http`, `fetch`, `fs`, etc.

_So I have been coming up with a plan to fix this._

# Playtesting

The first 2 things I need are a ClearScript environment and an installation of Node.JS, so I can compare the two V8 Engines. To install node, visit [nodejs.org](https://nodejs.org/en/download/package-manager). To setup ClearScript see below:

## ClearScript Setup

### Dependencies

We're gonna need a few modules. Firstly, we need the module that makes this series possible, and that is my Import-Package module. Second, we need tooling to setup a dispatcher in a second PowerShell runspace to handle asynchronous callbacks. For that we can use New-ThreadController.

```powershell
Install-Module Import-Package
Install-Module New-ThreadController

Import-Module Import-Package
Import-Module New-ThreadController
```

Next we need to actually import the Microsoft.ClearScript CSharp Package into the PowerShell session:

```powershell
Import-Package "Microsoft.ClearScript"
```

Don't worry about running `Install-Package`. `Install-Package` is slow and buggy, and `Import-Package` weeds some of the slowness and bugs out.

### Setting Up The Second Thread
We do need a secondary PowerShell thread with a dispatcher. Currently C# only ships one Dispatcher and its only for WPF, which means it (as I am aware) it is not currently supported on Linux and Mac OS. However, New-ThreadController has a custom written backup dispatcher in case the WPF one isn't available. New-ThreadController also internally handles setting up of the C# Thread, the PowerShell Runspace, and the associated Dispatcher and starts all of them. All we need to do is name the thread, and setup a session proxy:

```powershell
$callback_thread = & {
  $doc_queue_type = @(
    "System.Collections.Concurrent.ConcurrentQueue"
    "["
      "Microsoft.ClearScript.DocumentInfo"
    "]"
  ) -join ""
  
  $shared = [hashtable]::Synchronized(@{
    "DocumentQueue" = (New-Object -TypeName $doc_queue_type)
  })
  $thread = New-ThreadController -Name "LoadCallback" -SessionProxies @{
    "Shared" = $shared # kv pair, where the key will be the var name in the new thread
  }
  # Attach the session proxy value for easy access:
  $thread | Add-Member `
    -Name "Shared" `
    -MemberType NoteProperty `
    -Value $shared
  $thread
}
```

### Add A CSharp Class for Handling Callbacks
In this specific case, we will be making a class to handle ClearScript LoadCallbacks:

```csharp
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
  public static object ThreadDispatcher { get; set; }
  public static Action Callback { get; set; }
  public static Hashtable Shared { get; set; }

  public static void Run( ref Microsoft.ClearScript.DocumentInfo documentInfo )
  {
    ConcurrentQueue<Microsoft.ClearScript.DocumentInfo> q = (ConcurrentQueue<Microsoft.ClearScript.DocumentInfo>) Shared["DocumentQueue"];
    q.Enqueue( documentInfo );

    // WPF's Dispatcher
    if (ThreadDispatcher is System.Windows.Threading.Dispatcher wpfDispatcher)
    {
        wpfDispatcher.InvokeAsync(Callback).Task.GetAwaiter().GetResult();
    }
    else // New-ThreadController's Dispatcher
    {
      var dispatcherType = ThreadDispatcher.GetType();
      var method = dispatcherType.GetMethod("InvokeAsync", new Type[] { typeof(Action) });

      if (method != null)
      {
          var task = (Task) method.Invoke(ThreadDispatcher, new object[] { Callback });
          task.GetAwaiter().GetResult();
      }
      else
      {
          throw new InvalidOperationException("Dispatcher must have an InvokeAsync method.");
      }
    }
  }
}
```

Store that as a string in PowerShell, and add it with this Add-Type command:

```powershell
$source_code = @"
...
"@

Add-Type `
  -TypeDefinition $source_code `
  -Language CSharp `
  -IgnoreWarnings ` # Ignore warnings is to suppress the warnings about ClearScript.Core
  -ReferencedAssemblies @(
    & {
      # Workaround to get WindowsBase.dll when it refuses to cooperate
      $assembly = [System.AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_ -like "*WindowsBase*" }
      $assembly.Location
    }
    "ClearScript.Core"
    "System.Collections.Concurrent"
    "Microsoft.CSharp"
    "System.Linq"
    "System.Console"
  )
```

Now let's setup that class:

```powershell
[LoadCallback]::ThreadDispatcher = $callback_thread.Dispatcher
[LoadCallback]::Shared = $callback_thread.Shared

# We require the scriptblock's AST for multithreading and we cast to an Action, so ClearScript can run it
[LoadCallback]::Callback = [System.Action] {
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
```

### ClearScript V8 Engine Options

Next we need to go over some V8 configuration options. Here are the basic ones from the ClearScript documentation:
- I have commented out the options that we won't be using in this post, but you can uncomment them if you want to use them.

```powershell
$options = @{
  "port" = 9223

  "search_directories" = @(

    $pwd
    # (Resolve-Path node_modules).ToString()
    # whatever dirs you want to search when calling require or import

  ) -join ";" # ClearScript uses semicolons to separate paths

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
```

### Startin' Up The Engine

Alright, home stretch. Let's start up the engine:

```powershell
$runtime = [Microsoft.ClearScript.V8.V8Runtime]::new( $options.runtime, $options.port )

$runtime.DocumentSettings.AccessFlags = $options.document
$runtime.DocumentSettings.SearchPaths = $options.search_directories
$runtime.DocumentSettings.LoadCallback = [Microsoft.ClearScript.DocumentLoadCallback][LoadCallback]::Run

$engine = $runtime.CreateScriptEngine( $options.engine )
$engine.DocumentSettings.AccessFlags = $runtime.DocumentSettings.AccessFlags
$engine.DocumentSettings.SearchPath = $runtime.DocumentSettings.SearchPath
$engine.DocumentSettings.LoadCallback = $runtime.DocumentSettings.LoadCallback
$engine.AllowReflection = $true

# If you want to expose C# APIs to the JS engine, you can do so like this:
# $engine.AddHostObject("host", [Microsoft.ClearScript.ExtendedHostFunctions]::new() )
```

To help with playtesting, we can connect ClearScript to a debugger. As of right now, I haven't figured out how to connect Chrome/Edge's Inspector to ClearScript, but VSCode's debugger works just fine. To use it, you will need to add the following to your launch.json:

```json
{
  "type" : "node",
  "request" : "attach",
  "name" : "Attach to ClearScript V8 (9223)",
  "address" : "127.0.0.1",
  "port" : 9223
}
```

## Node.JS Porting

Fantastic! I've got you guys a V8 engine. Now, I just need to port Node's APIs into PowerShell. At first this seemed daunting (and it still is), but I've come up with a plan to make it easier.

One of the complexities of working with V8 Engines and their APIs, is that JS comes in many flavors, even in V8. Specifically, V8 has 4 types of documents that it can parse: ES6 Modules, CommonJS Modules, regular scripts, and JSON. JSON is JSON, so we don't need to worry about that, but the other 3 are gonna need some work.

To setup each of those 3, we can use the following:

```powershell
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
  # "json" = New-Object Microsoft.ClearScript.DocumentInfo -Property @{
  #   "Category" = [Microsoft.ClearScript.DocumentCategory]::JSON
  # } -ArgumentList "[PowerShell JSON eval]"
}

$engine.Evaluate( $descriptors.es6, "'hello from ES6'" )
$engine.Evaluate( $descriptors.commonjs, "'hello from CommonJS'" )
# $engine.Evaluate( $descriptors.script, "'hello from JS'" )
$engine.Evaluate( "'hello from JS'" ) # The default is a script
```

To access variables, you can do so with `$engine.Script` and `$engine.Global`.

To figure out what APIs need to be ported, we can compare the `globalThis` object from ClearScript and Node.JS. Now as far as I am aware, the `globalThis` object is shared across all files in a V8 engine, so we only need to evaluate it once:

```powershell
$apis = @{
  "node" = node -e "Object.getOwnPropertyNames(this).forEach(name => { console.log( name )})"
  "clearscript" = $engine.Evaluate( "Object.getOwnPropertyNames(globalThis)" )
}

Compare-Object $apis.node $apis.base
```

Currently, these are the differences between the 2:

| Node.JS has | ClearScript has  |
|-------------|------------------|
| `process`   | `gc`             |
| `global`    | `EngineInternal` |
| `Buffer`    | `host`           |
| `clearImmediate` | |
| `setImmediate` | |
| `URL` | |
| `URLSearchParams` | |
| `DOMException` | |
| `AbortController` | |
| `AbortSignal` | |
| `Event` | |
| `EventTarget` | |
| `TextEncoder` | |
| `TextDecoder` | |
| `TransformStream` | |
| `TransformStreamDefaultController` | |
| `WritableStream` | |
| `WritableStreamDefaultController` | |
| `WritableStreamDefaultWriter` | |
| `ReadableStream` | |
| `ReadableStreamDefaultReader` | |
| `ReadableStreamBYOBReader` | |
| `ReadableStreamBYOBRequest` | |
| `ReadableByteStreamController` | |
| `ReadableStreamDefaultController` | |
| `ByteLengthQueuingStrategy` | |
| `CountQueuingStrategy` | |
| `TextEncoderStream` | |
| `TextDecoderStream` | |
| `CompressionStream` | |
| `DecompressionStream` | |
| `clearInterval` | |
| a bunch ... | |
| `vm` | |
| another bunch ... | |

Now some of these are going to be easy to replicate like `__filename` and `__dirname`. One I want to explore next is `vm`, since I think I can replicate it with ClearScript's APIs.

# Final Thoughts and Next Steps

I'm in college full time and I have a full time job, so I don't have all the time to work on this, but I think I can pull of doing a module per week. So next week, I'm gonna post my progress on porting `vm` to ClearScript. We'll see how it goes from there. Wish me luck!