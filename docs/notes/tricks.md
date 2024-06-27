# Getting ClearScript to work in Chrome Inspector:

- use port 9222

# Node.JS internals:

- https://github.com/nodejs/help/issues/3079#issuecomment-739503891

```js
require('internal/test/binding')`
```

as well as

- https://github.com/nodejs/node/blob/a072ec382f8b8a2e2e90e2520c1b94a668b4bc3b/lib/internal/bootstrap/realm.js#L1-L43

```js
// - internalBinding(): the private internal C++ binding loader, inaccessible
//   from user land unless through `require('internal/test/binding')`.
//   These C++ bindings are created using NODE_BINDING_CONTEXT_AWARE_INTERNAL()
//   and have their nm_flags set to NM_F_INTERNAL.
```

- https://github.com/nodejs/node/blob/a072ec382f8b8a2e2e90e2520c1b94a668b4bc3b/src/node_binding.h#L59-L70

```c++
#define NODE_BINDING_CONTEXT_AWARE_CPP(modname, regfunc, priv, flags)          \
  static node::node_module _module = {                                         \
      NODE_MODULE_VERSION,                                                     \
      flags,                                                                   \
      nullptr,                                                                 \
      __FILE__,                                                                \
      nullptr,                                                                 \
      (node::addon_context_register_func)(regfunc),                            \
      NODE_STRINGIFY(modname),                                                 \
      priv,                                                                    \
      nullptr};                                                                \
  void _register_##modname() { node_module_register(&_module); }
```
- https://github.com/nodejs/node/blob/a072ec382f8b8a2e2e90e2520c1b94a668b4bc3b/src/node_binding.h#L90-L91

```c++
#define NODE_BINDING_CONTEXT_AWARE_INTERNAL(modname, regfunc)                  \
  NODE_BINDING_CONTEXT_AWARE_CPP(modname, regfunc, nullptr, NM_F_INTERNAL)
```

- https://github.com/nodejs/node/blob/a072ec382f8b8a2e2e90e2520c1b94a668b4bc3b/src/node_binding.h#L15C1-L20C3

```c++
enum {
  NM_F_BUILTIN = 1 << 0,  // Unused.
  NM_F_LINKED = 1 << 1,
  NM_F_INTERNAL = 1 << 2,
  NM_F_DELETEME = 1 << 3,
};
```
powershell equivalent
```powershell
enum NM_F {
  BUILTIN = 1 -shl 0  # 1 << 0 = 1
  LINKED = 1 -shl 1   # 1 << 1 = 2
  INTERNAL = 1 -shl 2 # 1 << 2 = 4
  DELETEME = 1 -shl 3 # 1 << 3 = 8
}

# Assigning Enum Values
$builtinFlag = [NM_F]::BUILTIN
$linkedFlag = [NM_F]::LINKED
$internalFlag = [NM_F]::INTERNAL
$deleteMeFlag = [NM_F]::DELETEME

# Output Enum Values
Write-Output $builtinFlag    # Output: BUILTIN
Write-Output [int]$builtinFlag   # Output: 1

Write-Output $linkedFlag     # Output: LINKED
Write-Output [int]$linkedFlag    # Output: 2

Write-Output $internalFlag   # Output: INTERNAL
Write-Output [int]$internalFlag  # Output: 4

Write-Output $deleteMeFlag   # Output: DELETEME
Write-Output [int]$deleteMeFlag  # Output: 8

# Combining Enum Values
$combinedFlags = [NM_F]::LINKED -bor [NM_F]::INTERNAL
Write-Output $combinedFlags   # Output: LINKED, INTERNAL
Write-Output [int]$combinedFlags # Output: 6
```

Altogether how to find internal bindings: https://github.com/search?q=repo%3Anodejs%2Fnode%20NODE_BINDING_CONTEXT_AWARE_INTERNAL&type=code

NODE_BINDING_CONTEXT_AWARE_INTERNAL is a macro, and the arguments are interpreted as strings. The first argument is the name of the internalBinding.

## List of Internals:
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/quic/quic.cc#L50
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/uv.cc#L140
https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_dir.cc#L466
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/signal_wrap.cc#L177
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_credentials.cc#L504
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_snapshotable.cc#L1635
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_config.cc#L83
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/timers.cc#L196
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_sea.cc#L643
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_types.cc#L88
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/stream_pipe.cc#L335
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/internal_only_v8.cc#L82
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_v8.cc#L506
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_report_module.cc#L235
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/doc/contributing/adding-v8-fast-api.md?plain=1#L130
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/spawn_sync.cc#L1120
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/pipe_wrap.cc#L254
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/async_wrap.cc#L731
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/inspector_profiler.cc#L579
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_webstorage.cc#L706
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_util.cc#L392
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_process_methods.cc#L716
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_watchdog.cc#L437
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/tty_wrap.cc#L157
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node.cc#L1487
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/udp_wrap.cc#L839
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_url.cc#L563
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_wasi.cc#L1336
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/stream_wrap.cc#L418
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/module_wrap.cc#L1100
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_i18n.cc#L914
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_builtins.cc#L769
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/permission/permission.cc#L181
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_task_queue.cc#L196
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_zlib.cc#L1463
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/js_stream.cc#L226
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/crypto/crypto_tls.cc#L2239
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_crypto.cc#L95
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_symbols.cc#L32
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_modules.cc#L452
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/tcp_wrap.cc#L446
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_perf.cc#L402
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/encoding_binding.cc#L251
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_file.cc#L3462
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_contextify.cc#L1855
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/cares_wrap.cc#L2023
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/string_decoder.cc#L345
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_blob.cc#L583
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_messaging.cc#L1724
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_serdes.cc#L541
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_constants.cc#L1371
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/heap_utils.cc#L496
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_errors.cc#L1310
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_os.cc#L433
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_sockaddr.cc#L887
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/js_udp_wrap.cc#L220
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/process_wrap.cc#L344
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_worker.cc#L1020
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_options.cc#L1515
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_http2.cc#L3469
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_http_parser.cc#L1367
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_wasm_web_api.cc#L210
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_buffer.cc#L1558
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/inspector_js_api.cc#L402
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/fs_event_wrap.cc#L243
- https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_trace_events.cc#L170

# How Node.JS loads commonjs modules:

```js
let loader = require('node:internal/modules/cjs/loader')
console.log( loader.wrapSafe )
```

Then inspect the function definition:

```js
const {
  containsModuleSyntax,
  compileFunctionForCJSLoader,
} = internalBinding('contextify');

// ...

function wrapSafe(filename, content, cjsModuleInstance, codeCache, format) {
  assert(format !== 'module');  // ESM should be handled in loadESMFromCJS().
  const hostDefinedOptionId = vm_dynamic_import_default_internal;
  const importModuleDynamically = vm_dynamic_import_default_internal;
  if (patched) {
    const wrapped = Module.wrap(content);
    const script = makeContextifyScript(
      wrapped,                 // code
      filename,                // filename
      0,                       // lineOffset
      0,                       // columnOffset
      undefined,               // cachedData
      false,                   // produceCachedData
      undefined,               // parsingContext
      hostDefinedOptionId,     // hostDefinedOptionId
      importModuleDynamically, // importModuleDynamically
    );

    // Cache the source map for the module if present.
    const { sourceMapURL } = script;
    if (sourceMapURL) {
      maybeCacheSourceMap(filename, content, cjsModuleInstance, false, undefined, sourceMapURL);
    }

    return {
      __proto__: null,
      function: runScriptInThisContext(script, true, false),
      sourceMapURL,
    };
  }

  const isMain = !!(cjsModuleInstance && cjsModuleInstance[kIsMainSymbol]);
  const shouldDetectModule = (format !== 'commonjs' && getOptionValue('--experimental-detect-module'));
  const result = compileFunctionForCJSLoader(content, filename, isMain, shouldDetectModule);

  // cachedDataRejected is only set for cache coming from SEA.
  if (codeCache &&
      result.cachedDataRejected !== false &&
      internalBinding('sea').isSea()) {
    process.emitWarning('Code cache data rejected.');
  }

  // Cache the source map for the module if present.
  if (result.sourceMapURL) {
    maybeCacheSourceMap(filename, content, cjsModuleInstance, false, undefined, result.sourceMapURL);
  }

  return result;
}
```

- CompileFunctionForCJSLoader: https://github.com/nodejs/node/blob/67c19c2900506cd4c60016765e0b7954409dcf90/src/node_contextify.cc#L1456-L1539

```c++
static MaybeLocal<Function> CompileFunctionForCJSLoader(Environment* env,
                                                        Local<Context> context,
                                                        Local<String> code,
                                                        Local<String> filename,
                                                        bool* cache_rejected,
                                                        bool is_cjs_scope) {
  Isolate* isolate = context->GetIsolate();
  EscapableHandleScope scope(isolate);

  Local<Symbol> symbol = env->vm_dynamic_import_default_internal();
  Local<PrimitiveArray> hdo =
      loader::ModuleWrap::GetHostDefinedOptions(isolate, symbol);
  ScriptOrigin origin(filename,
                      0,               // line offset
                      0,               // column offset
                      true,            // is cross origin
                      -1,              // script id
                      Local<Value>(),  // source map URL
                      false,           // is opaque
                      false,           // is WASM
                      false,           // is ES Module
                      hdo);
  ScriptCompiler::CachedData* cached_data = nullptr;

  bool used_cache_from_sea = false;
#ifndef DISABLE_SINGLE_EXECUTABLE_APPLICATION
  if (sea::IsSingleExecutable()) {
    sea::SeaResource sea = sea::FindSingleExecutableResource();
    if (sea.use_code_cache()) {
      std::string_view data = sea.code_cache.value();
      cached_data = new ScriptCompiler::CachedData(
          reinterpret_cast<const uint8_t*>(data.data()),
          static_cast<int>(data.size()),
          v8::ScriptCompiler::CachedData::BufferNotOwned);
      used_cache_from_sea = true;
    }
  }
#endif

  CompileCacheEntry* cache_entry = nullptr;
  if (!used_cache_from_sea && env->use_compile_cache()) {
    cache_entry = env->compile_cache_handler()->GetOrInsert(
        code, filename, CachedCodeType::kCommonJS);
  }
  if (cache_entry != nullptr && cache_entry->cache != nullptr) {
    // source will take ownership of cached_data.
    cached_data = cache_entry->CopyCache();
  }

  ScriptCompiler::Source source(code, origin, cached_data);
  ScriptCompiler::CompileOptions options;
  if (cached_data == nullptr) {
    options = ScriptCompiler::kNoCompileOptions;
  } else {
    options = ScriptCompiler::kConsumeCodeCache;
  }

  std::vector<Local<String>> params;
  if (is_cjs_scope) {
    params = GetCJSParameters(env->isolate_data());
  }
  MaybeLocal<Function> maybe_fn = ScriptCompiler::CompileFunction(
      context,
      &source,
      params.size(),
      params.data(),
      0,       /* context extensions size */
      nullptr, /* context extensions data */
      // TODO(joyeecheung): allow optional eager compilation.
      options);

  Local<Function> fn;
  if (!maybe_fn.ToLocal(&fn)) {
    return scope.EscapeMaybe(MaybeLocal<Function>());
  }

  if (options == ScriptCompiler::kConsumeCodeCache) {
    *cache_rejected = source.GetCachedData()->rejected;
  }
  if (cache_entry != nullptr) {
    env->compile_cache_handler()->MaybeSave(cache_entry, fn, *cache_rejected);
  }
  return scope.Escape(fn);
}
```