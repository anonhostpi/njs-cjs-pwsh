# All InternalBinding Calls:

## node:internal/bootstrap/realm (x8):
- Line 155: `      return internalBinding(module);`
- Line 161: `      return internalBinding(module);`
- Line 177: ` * Set up internalBinding() in the closure.`
- Line 184: `  internalBinding = function internalBinding(module) {`
- Line 187: `      mod = bindingObj[module] = getInternalBinding(module);`
- Line 199: `} = internalBinding('builtins');`
- Line 201: `const { ModuleWrap } = internalBinding('module_wrap');`
- Line 447: `  } = internalBinding('errors');`

## node:internal/errors (x3):
- Line 617: `  uvBinding ??= internalBinding('uv');`
- Line 909: `      const info = internalBinding('os').getOSInformation();`
- Line 939: `} = internalBinding('util');`

## node:internal/bootstrap/node (x11):
- Line 68: `const config = internalBinding('config');`
- Line 86: `} = internalBinding('util');`
- Line 138: `const binding = internalBinding('builtins');`
- Line 158: `const rawMethods = internalBinding('process_methods');`
- Line 194: `const credentials = internalBinding('credentials');`
- Line 208: `internalBinding('async_wrap').setupHooks(nativeHooks);`
- Line 222: `const { setTraceCategoryStateUpdateHandler } = internalBinding('trace_events');`
- Line 303: `internalBinding('process_methods').setEmitWarningSync(emitWarningSync);`
- Line 317: `  const { setupTimers } = internalBinding('timers');`
- Line 338: `  } = internalBinding('errors');`
- Line 405: `  const bufferBinding = internalBinding('buffer');`

## node:internal/timers (x1):
- Line 84: `const binding = internalBinding('timers');`

## node:internal/async_hooks (x5):
- Line 11: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`
- Line 13: `const async_wrap = internalBinding('async_wrap');`
- Line 83: `const { enqueueMicrotask } = internalBinding('task_queue');`
- Line 84: `const { resource_symbol, owner_symbol } = internalBinding('symbols');`
- Line 96: `        trigger_async_id_symbol } = internalBinding('symbols');`

## node:internal/validators (x1):
- Line 37: `const { signals } = internalBinding('constants').os;`

## node:internal/util (x9):
- Line 57: `const { signals } = internalBinding('constants').os;`
- Line 66: `} = internalBinding('util');`
- Line 67: `const { isNativeError, isPromise } = internalBinding('types');`
- Line 69: `const { encodings } = internalBinding('string_decoder');`
- Line 80: `  uvBinding ??= internalBinding('uv');`
- Line 698: `  _DOMException ??= internalBinding('messaging').DOMException;`
- Line 703: `  _DOMException ??= internalBinding('messaging').DOMException;`
- Line 831: `    internalBinding('profiler').setCoverageDirectory(coverageDirectory);`
- Line 832: `    internalBinding('profiler').setSourceMapCacheGetter(sourceMapCacheToObject);`

## node:internal/options (x1):
- Line 7: `} = internalBinding('options');`

## node:internal/util/types (x1):
- Line 58: `  ...internalBinding('types'),`

## node:internal/util/inspect (x3):
- Line 112: `} = internalBinding('util');`
- Line 2323: `if (internalBinding('config').hasIntl) {`
- Line 2324: `  const icu = internalBinding('icu');`

## node:internal/util/debuglog (x1):
- Line 23: `const { isTraceCategoryEnabled, trace } = internalBinding('trace_events');`

## node:buffer (x4):
- Line 73: `} = internalBinding('buffer');`
- Line 80: `} = internalBinding('util');`
- Line 1216: `if (internalBinding('config').hasIntl) {`
- Line 1220: `  } = internalBinding('icu');`

## node:internal/buffer (x2):
- Line 34: `} = internalBinding('buffer');`
- Line 40: `} = internalBinding('util');`

## node:internal/worker/js_transferable (x3):
- Line 11: `} = internalBinding('symbols');`
- Line 14: `} = internalBinding('messaging');`
- Line 24: `} = internalBinding('util');`

## node:internal/process/per_thread (x4):
- Line 51: `const constants = internalBinding('constants').os.signals;`
- Line 58: `const { exitCodes: { kNoFailure } } = internalBinding('errors');`
- Line 60: `const binding = internalBinding('process_methods');`
- Line 286: `  } = internalBinding('options');`

## node:internal/fs/utils (x1):
- Line 109: `} = internalBinding('constants');`

## node:internal/url (x2):
- Line 91: `const bindingUrl = internalBinding('url');`
- Line 1173: `  const bindingBlob = internalBinding('blob');`

## node:internal/process/task_queues (x1):
- Line 16: `} = internalBinding('task_queue');`

## node:internal/process/promises (x2):
- Line 21: `} = internalBinding('task_queue');`
- Line 29: `} = internalBinding('errors');`

## node:timers (x1):
- Line 32: `const binding = internalBinding('timers');`

## node:internal/process/execution (x3):
- Line 19: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`
- Line 30: `const { containsModuleSyntax } = internalBinding('contextify');`
- Line 37: `const { shouldAbortOnUncaughtToggle } = internalBinding('util');`

## node:internal/vm (x3):
- Line 11: `} = internalBinding('contextify');`
- Line 20: `} = internalBinding('symbols');`
- Line 32: `} = internalBinding('util');`

## node:internal/source_map/source_map_cache (x1):
- Line 21: `} = internalBinding('errors');`

## node:internal/modules/helpers (x1):
- Line 30: `const { canParse: URLCanParse } = internalBinding('url');`

## node:fs (x2):
- Line 46: `const { fs: constants } = internalBinding('constants');`
- Line 65: `const binding = internalBinding('fs');`

## node:internal/blob (x2):
- Line 27: `} = internalBinding('blob');`
- Line 30: `} = internalBinding('buffer');`

## node:internal/encoding (x3):
- Line 52: `const binding = internalBinding('encoding_binding');`
- Line 390: `  internalBinding('config').hasIntl ?`
- Line 398: `  } = internalBinding('icu');`

## node:internal/webstreams/util (x2):
- Line 30: `} = internalBinding('buffer');`
- Line 41: `} = internalBinding('util');`

## node:util (x1):
- Line 75: `const binding = internalBinding('util');`

## node:internal/process/permission (x1):
- Line 8: `const permission = internalBinding('permission');`

## node:internal/bootstrap/web/exposed-wildcard (x2):
- Line 20: `const config = internalBinding('config');`
- Line 68: `    const { setConsoleExtensionInstaller } = internalBinding('inspector');`

## node:internal/console/constructor (x4):
- Line 37: `const { trace } = internalBinding('trace_events');`
- Line 51: `const { previewEntries } = internalBinding('util');`
- Line 651: `  if (!internalBinding('config').hasInspector || !isBuildingSnapshot()) {`
- Line 654: `  const { console: consoleFromVM } = internalBinding('inspector');`

## node:internal/util/inspector (x2):
- Line 49: `  const { hasInspector } = internalBinding('config');`
- Line 85: `  const { consoleCall, console: consoleFromVM } = internalBinding('inspector');`

## node:internal/perf/utils (x1):
- Line 10: `} = internalBinding('performance');`

## node:internal/bootstrap/web/exposed-window-or-worker (x2):
- Line 35: `const { structuredClone } = internalBinding('messaging');`
- Line 90: `internalBinding('wasm_web_api').setImplementation((streamState, source) => {`

## node:internal/bootstrap/switches/is_main_thread (x5):
- Line 7: `const rawMethods = internalBinding('process_methods');`
- Line 297: `internalBinding('module_wrap');`
- Line 304: `if (internalBinding('config').hasInspector) {`
- Line 308: `internalBinding('wasm_web_api');`
- Line 310: `internalBinding('worker');`

## node:internal/v8/startup_snapshot (x1):
- Line 19: `} = internalBinding('mksnapshot');`

## node:internal/process/signal (x2):
- Line 12: `const { signals } = internalBinding('constants').os;`
- Line 25: `      Signal = internalBinding('signal_wrap').Signal;`

## node:url (x1):
- Line 63: `const bindingUrl = internalBinding('url');`

## node:internal/modules/cjs/loader (x8):
- Line 72: `} = internalBinding('util');`
- Line 74: `const { kEvaluated } = internalBinding('module_wrap');`
- Line 137: `} = internalBinding('contextify');`
- Line 142: `const { internalModuleStat } = internalBinding('fs');`
- Line 143: `const { safeGetenv } = internalBinding('credentials');`
- Line 160: `} = internalBinding('symbols');`
- Line 1381: `      internalBinding('sea').isSea()) {`
- Line 1444: `      inspectorWrapper = internalBinding('inspector').callAndPauseOnStart;`

## node:internal/modules/package_json_reader (x1):
- Line 10: `const modulesBinding = internalBinding('modules');`

## node:internal/modules/esm/utils (x4):
- Line 14: `} = internalBinding('util');`
- Line 21: `} = internalBinding('symbols');`
- Line 23: `const { ModuleWrap } = internalBinding('module_wrap');`
- Line 45: `} = internalBinding('module_wrap');`

## node:internal/process/pre_execution (x14):
- Line 79: `  } = internalBinding('util');`
- Line 82: `  } = internalBinding('symbols');`
- Line 127: `    assert(internalBinding('worker').isMainThread);`
- Line 148: `    assert(!internalBinding('worker').isMainThread);`
- Line 219: `  const binding = internalBinding('process_methods');`
- Line 353: `  if (internalBinding('config').hasOpenSSL) {`
- Line 467: `  const { isTraceCategoryEnabled } = internalBinding('trace_events');`
- Line 478: `  if (internalBinding('config').hasInspector) {`
- Line 483: `    internalBinding('inspector').registerAsyncHook(enable, disable);`
- Line 496: `  const utilBinding = internalBinding('util');`
- Line 529: `  const { noBrowserGlobals } = internalBinding('config');`
- Line 685: `  internalBinding('mksnapshot').runEmbedderPreload(process, require);`
- Line 702: `  internalBinding('performance').markBootstrapComplete();`
- Line 724: `  const threadId = internalBinding('worker').threadId;`

## node:internal/inspector_async_hook (x2):
- Line 11: `  const inspector = internalBinding('inspector');`
- Line 13: `  config = internalBinding('config');`

## node:internal/modules/run_main (x3):
- Line 8: `const { getNearestParentPackageJSONType } = internalBinding('modules');`
- Line 18: `} = internalBinding('errors');`
- Line 23: `} = internalBinding('util');`

## node:internal/dns/utils (x1):
- Line 31: `  binding ??= internalBinding('cares_wrap');`

## node:internal/net (x1):
- Line 10: `const { writeBuffer } = internalBinding('fs');`

## node:internal/bootstrap/switches/does_own_process_state (x2):
- Line 3: `const credentials = internalBinding('credentials');`
- Line 4: `const rawMethods = internalBinding('process_methods');`

## node:internal/test/binding (x2):
- Line 13: `function filteredInternalBinding(id) {`
- Line 25: `  return internalBinding(id);`

## node:vm (x2):
- Line 37: `} = internalBinding('contextify');`
- Line 68: `} = internalBinding('symbols');`

## node:internal/modules/esm/loader (x3):
- Line 22: `const { imported_cjs_symbol } = internalBinding('symbols');`
- Line 39: `const { canParse } = internalBinding('url');`
- Line 40: `const { ModuleWrap, kEvaluating, kEvaluated } = internalBinding('module_wrap');`

## node:net (x4):
- Line 64: `} = internalBinding('uv');`
- Line 67: `const { ShutdownWrap } = internalBinding('stream_wrap');`
- Line 72: `} = internalBinding('tcp_wrap');`
- Line 77: `} = internalBinding('pipe_wrap');`

## node:internal/abort_controller (x1):
- Line 53: `} = internalBinding('messaging');`

## node:string_decoder (x1):
- Line 41: `} = internalBinding('string_decoder');`

## node:internal/stream_base_commons (x2):
- Line 17: `} = internalBinding('stream_wrap');`
- Line 18: `const { UV_EOF } = internalBinding('uv');`

## node:diagnostics_channel (x1):
- Line 30: `const { triggerUncaughtException } = internalBinding('errors');`

## node:internal/perf/observe (x1):
- Line 36: `} = internalBinding('performance');`

## node:_http_common (x1):
- Line 31: `const { methods, allMethods, HTTPParser } = internalBinding('http_parser');`

## node:internal/http (x1):
- Line 11: `const { trace, isTraceCategoryEnabled } = internalBinding('trace_events');`

## node:_http_server (x1):
- Line 52: `const { ConnectionsList } = internalBinding('http_parser');`

## node:internal/js_stream_socket (x2):
- Line 10: `const { JSStream } = internalBinding('js_stream');`
- Line 11: `const uv = internalBinding('uv');`

## node:_tls_common (x2):
- Line 47: `} = internalBinding('constants');`
- Line 72: `} = internalBinding('crypto');`

## node:tls (x2):
- Line 63: `const { getRootCertificates, getSSLCiphers } = internalBinding('crypto');`
- Line 65: `const { canonicalizeIP } = internalBinding('cares_wrap');`

## node:_tls_wrap (x5):
- Line 63: `const { TCP, constants: TCPConstants } = internalBinding('tcp_wrap');`
- Line 64: `const tls_wrap = internalBinding('tls_wrap');`
- Line 65: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`
- Line 68: `const { SecureContext: NativeSecureContext } = internalBinding('crypto');`
- Line 88: `const { onpskexchange: kOnPskExchange } = internalBinding('symbols');`

## node:crypto (x2):
- Line 42: `const constants = internalBinding('constants').crypto;`
- Line 48: `} = internalBinding('crypto');`

## node:internal/crypto/random (x1):
- Line 31: `} = internalBinding('crypto');`

## node:internal/crypto/pbkdf2 (x1):
- Line 13: `} = internalBinding('crypto');`

## node:internal/crypto/util (x2):
- Line 33: `} = internalBinding('crypto');`
- Line 41: `} = internalBinding('constants');`

## node:internal/crypto/scrypt (x1):
- Line 13: `} = internalBinding('crypto');`

## node:internal/crypto/hkdf (x1):
- Line 11: `} = internalBinding('crypto');`

## node:internal/crypto/keys (x1):
- Line 27: `} = internalBinding('crypto');`

## node:internal/crypto/keygen (x1):
- Line 26: `} = internalBinding('crypto');`

## node:internal/crypto/diffiehellman (x2):
- Line 20: `} = internalBinding('crypto');`
- Line 66: `} = internalBinding('constants');`

## node:internal/crypto/cipher (x2):
- Line 16: `} = internalBinding('crypto');`
- Line 23: `} = internalBinding('constants');`

## node:internal/crypto/sig (x1):
- Line 33: `} = internalBinding('crypto');`

## node:internal/crypto/hash (x1):
- Line 16: `} = internalBinding('crypto');`

## node:internal/crypto/x509 (x1):
- Line 17: `} = internalBinding('crypto');`

## node:internal/crypto/certificate (x1):
- Line 7: `} = internalBinding('crypto');`

## node:internal/tls/secure-context (x1):
- Line 44: `} = internalBinding('constants');`

## node:child_process (x1):
- Line 63: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`

## node:internal/child_process (x8):
- Line 45: `const { Process } = internalBinding('process_wrap');`
- Line 52: `} = internalBinding('stream_wrap');`
- Line 53: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`
- Line 54: `const { TCP } = internalBinding('tcp_wrap');`
- Line 55: `const { TTY } = internalBinding('tty_wrap');`
- Line 56: `const { UDP } = internalBinding('udp_wrap');`
- Line 61: `const spawn_sync = internalBinding('spawn_sync');`
- Line 75: `} = internalBinding('uv');`

## node:dgram (x2):
- Line 74: `const { UV_UDP_REUSEADDR } = internalBinding('constants').os;`
- Line 80: `} = internalBinding('udp_wrap');`

## node:internal/dgram (x2):
- Line 11: `const { UDP } = internalBinding('udp_wrap');`
- Line 17: `const { UV_EINVAL } = internalBinding('uv');`

## node:internal/cluster/round_robin_handle (x1):
- Line 13: `const { constants } = internalBinding('tcp_wrap');`

## node:constants (x1):
- Line 33: `const constants = internalBinding('constants');`

## node:internal/crypto/webcrypto (x1):
- Line 22: `} = internalBinding('crypto');`

## node:dns (x1):
- Line 30: `const cares = internalBinding('cares_wrap');`

## node:internal/dns/callback_resolver (x1):
- Line 29: `} = internalBinding('cares_wrap');`

## node:internal/dns/promises (x1):
- Line 65: `} = internalBinding('cares_wrap');`

## node:internal/fs/promises (x2):
- Line 23: `const { fs: constants } = internalBinding('constants');`
- Line 32: `const binding = internalBinding('fs');`

## node:internal/fs/dir (x2):
- Line 13: `const binding = internalBinding('fs');`
- Line 14: `const dirBinding = internalBinding('fs_dir');`

## node:internal/fs/watchers (x3):
- Line 25: `} = internalBinding('fs');`
- Line 27: `const { FSEvent } = internalBinding('fs_event_wrap');`
- Line 28: `const { UV_ENOSPC } = internalBinding('uv');`

## node:internal/http2/core (x5):
- Line 187: `const { FileHandle } = internalBinding('fs');`
- Line 188: `const binding = internalBinding('http2');`
- Line 193: `} = internalBinding('stream_wrap');`
- Line 194: `const { UV_EOF } = internalBinding('uv');`
- Line 196: `const { StreamPipe } = internalBinding('stream_pipe');`

## node:internal/http2/compat (x1):
- Line 39: `} = internalBinding('http2');`

## node:internal/http2/util (x1):
- Line 21: `const binding = internalBinding('http2');`

## node:inspector (x3):
- Line 21: `const { hasInspector } = internalBinding('config');`
- Line 35: `const { _debugEnd } = internalBinding('process_methods');`
- Line 45: `} = internalBinding('inspector');`

## node:internal/worker (x1):
- Line 77: `} = internalBinding('worker');`

## node:internal/perf/event_loop_utilization (x1):
- Line 9: `} = internalBinding('performance');`

## node:internal/worker/io (x3):
- Line 31: `} = internalBinding('symbols');`
- Line 41: `} = internalBinding('messaging');`
- Line 44: `} = internalBinding('worker');`

## node:os (x3):
- Line 34: `const { safeGetenv } = internalBinding('credentials');`
- Line 35: `const constants = internalBinding('constants').os;`
- Line 61: `} = internalBinding('os');`

## node:perf_hooks (x1):
- Line 9: `} = internalBinding('performance');`

## node:internal/perf/usertiming (x1):
- Line 34: `const { structuredClone } = internalBinding('messaging');`

## node:internal/perf/nodetiming (x1):
- Line 31: `} = internalBinding('performance');`

## node:internal/histogram (x1):
- Line 15: `} = internalBinding('performance');`

## node:internal/perf/event_loop_delay (x1):
- Line 17: `} = internalBinding('performance');`

## node:repl (x2):
- Line 181: `} = internalBinding('util');`
- Line 185: `} = internalBinding('contextify');`

## node:internal/modules/esm/formats (x2):
- Line 10: `const fsBindings = internalBinding('fs');`
- Line 11: `const { fs: fsConstants } = internalBinding('constants');`

## node:internal/webstreams/transformstream (x1):
- Line 23: `} = internalBinding('messaging');`

## node:internal/webstreams/readablestream (x2):
- Line 43: `} = internalBinding('messaging');`
- Line 90: `const { structuredClone } = internalBinding('messaging');`

## node:internal/webstreams/writablestream (x1):
- Line 30: `} = internalBinding('messaging');`

## node:internal/webstreams/adapters (x3):
- Line 84: `} = internalBinding('stream_wrap');`
- Line 88: `const { UV_EOF } = internalBinding('uv');`
- Line 96: `      ObjectEntries(internalBinding('constants').zlib),`

## node:trace_events (x2):
- Line 8: `const { hasTracing } = internalBinding('config');`
- Line 21: `const { CategorySet, getEnabledCategories } = internalBinding('trace_events');`

## node:tty (x1):
- Line 31: `const { TTY, isTTY } = internalBinding('tty_wrap');`

## node:v8 (x6):
- Line 41: `} = internalBinding('serdes');`
- Line 47: `if (internalBinding('config').hasInspector) {`
- Line 48: `  profiler = internalBinding('profiler');`
- Line 52: `const { copy } = internalBinding('buffer');`
- Line 60: `} = internalBinding('heap_utils');`
- Line 105: `const binding = internalBinding('v8');`

## node:internal/heap_utils (x1):
- Line 26: `} = internalBinding('internal_only_v8');`

## node:internal/promise_hooks (x2):
- Line 11: `const { setPromiseHooks } = internalBinding('async_wrap');`
- Line 12: `const { triggerUncaughtException } = internalBinding('errors');`

## node:wasi (x2):
- Line 54: `        ({ WASI: _WASI } = internalBinding('wasi'));`
- Line 58: `        ({ WASI: _WASI } = internalBinding('wasi'));`

## node:zlib (x2):
- Line 65: `const binding = internalBinding('zlib');`
- Line 82: `const constants = internalBinding('constants').zlib;`

## node:internal/blocklist (x2):
- Line 11: `} = internalBinding('block_list');`
- Line 31: `const { owner_symbol } = internalBinding('symbols');`

## node:internal/socketaddress (x1):
- Line 12: `} = internalBinding('block_list');`

## node:internal/bootstrap/node (x11):
- Line 68: `const config = internalBinding('config');`
- Line 86: `} = internalBinding('util');`
- Line 138: `const binding = internalBinding('builtins');`
- Line 158: `const rawMethods = internalBinding('process_methods');`
- Line 194: `const credentials = internalBinding('credentials');`
- Line 208: `internalBinding('async_wrap').setupHooks(nativeHooks);`
- Line 222: `const { setTraceCategoryStateUpdateHandler } = internalBinding('trace_events');`
- Line 303: `internalBinding('process_methods').setEmitWarningSync(emitWarningSync);`
- Line 317: `  const { setupTimers } = internalBinding('timers');`
- Line 338: `  } = internalBinding('errors');`
- Line 405: `  const bufferBinding = internalBinding('buffer');`

## node:internal/bootstrap/switches/does_not_own_process_state (x2):
- Line 3: `const credentials = internalBinding('credentials');`
- Line 4: `const rawMethods = internalBinding('process_methods');`

## node:internal/bootstrap/switches/does_own_process_state (x2):
- Line 3: `const credentials = internalBinding('credentials');`
- Line 4: `const rawMethods = internalBinding('process_methods');`

## node:internal/bootstrap/switches/is_main_thread (x5):
- Line 7: `const rawMethods = internalBinding('process_methods');`
- Line 297: `internalBinding('module_wrap');`
- Line 304: `if (internalBinding('config').hasInspector) {`
- Line 308: `internalBinding('wasm_web_api');`
- Line 310: `internalBinding('worker');`

## node:internal/bootstrap/web/exposed-wildcard (x2):
- Line 20: `const config = internalBinding('config');`
- Line 68: `    const { setConsoleExtensionInstaller } = internalBinding('inspector');`

## node:internal/bootstrap/web/exposed-window-or-worker (x2):
- Line 35: `const { structuredClone } = internalBinding('messaging');`
- Line 90: `internalBinding('wasm_web_api').setImplementation((streamState, source) => {`

## node:internal/child_process/serialization (x1):
- Line 16: `const { streamBaseState, kLastWriteWasAsync } = internalBinding('stream_wrap');`

## node:internal/cluster/child (x1):
- Line 18: `const { exitCodes: { kNoFailure } } = internalBinding('errors');`

## node:internal/crypto/aes (x1):
- Line 33: `} = internalBinding('crypto');`

## node:internal/crypto/cfrg (x1):
- Line 18: `} = internalBinding('crypto');`

## node:internal/crypto/ec (x1):
- Line 18: `} = internalBinding('crypto');`

## node:internal/crypto/mac (x1):
- Line 14: `} = internalBinding('crypto');`

## node:internal/crypto/rsa (x1):
- Line 23: `} = internalBinding('crypto');`

## node:internal/debugger/inspect (x1):
- Line 50: `} = internalBinding('errors');`

## node:internal/debugger/inspect_repl (x1):
- Line 121: `const { builtinIds } = internalBinding('builtins');`

## node:internal/fs/cp/cp (x1):
- Line 36: `} = internalBinding('constants');`

## node:internal/fs/cp/cp-sync (x1):
- Line 27: `} = internalBinding('constants');`

## node:internal/fs/read/context (x1):
- Line 18: `const { FSReqCallback, close, read } = internalBinding('fs');`

## node:internal/legacy/processbinding (x1):
- Line 37: `    const { natives: result, configs } = internalBinding('builtins');`

## node:internal/main/check_syntax (x1):
- Line 73: `    const { ModuleWrap } = internalBinding('module_wrap');`

## node:internal/main/embedding (x1):
- Line 5: `const { isExperimentalSeaWarningNeeded } = internalBinding('sea');`

## node:internal/main/eval_string (x1):
- Line 37: `  const shouldDefineCrypto = isUsingCryptoIdentifier && internalBinding('config').hasOpenSSL;`

## node:internal/main/mksnapshot (x2):
- Line 16: `} = internalBinding('mksnapshot');`
- Line 18: `const { isExperimentalSeaWarningNeeded } = internalBinding('sea');`

## node:internal/main/print_help (x2):
- Line 19: `const { types } = internalBinding('options');`
- Line 35: `const { hasIntl, hasSmallICU, hasNodeOptions } = internalBinding('config');`

## node:internal/main/repl (x1):
- Line 19: `const { exitCodes: { kInvalidCommandLineArgument } } = internalBinding('errors');`

## node:internal/main/test_runner (x1):
- Line 17: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`

## node:internal/test_runner/runner (x1):
- Line 80: `} = internalBinding('errors');`

## node:internal/test_runner/harness (x2):
- Line 8: `const { getCallerLocation } = internalBinding('util');`
- Line 19: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`

## node:internal/test_runner/test (x1):
- Line 30: `const { getCallerLocation } = internalBinding('util');`

## node:internal/main/watch_mode (x1):
- Line 19: `} = internalBinding('errors');`

## node:internal/main/worker_thread (x3):
- Line 29: `} = internalBinding('worker');`
- Line 56: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`
- Line 146: `        internalBinding('module_wrap').callbackMap = new SafeWeakMap();`

## node:internal/modules/esm/get_format (x1):
- Line 22: `const { containsModuleSyntax } = internalBinding('contextify');`

## node:internal/modules/esm/hooks (x2):
- Line 35: `const { exitCodes: { kUnsettledTopLevelAwait } } = internalBinding('errors');`
- Line 37: `const { canParse: URLCanParse } = internalBinding('url');`

## node:internal/modules/esm/resolve (x3):
- Line 38: `const { canParse: URLCanParse } = internalBinding('url');`
- Line 39: `const { legacyMainResolve: FSLegacyMainResolve } = internalBinding('fs');`
- Line 57: `const { internalModuleStat } = internalBinding('fs');`

## node:internal/modules/esm/module_job (x3):
- Line 26: `const { ModuleWrap, kEvaluated } = internalBinding('module_wrap');`
- Line 31: `} = internalBinding('util');`
- Line 168: `        const initWrapper = internalBinding('inspector').callAndPauseOnStart;`

## node:internal/modules/esm/translators (x2):
- Line 32: `} = internalBinding('contextify');`
- Line 61: `const moduleWrap = internalBinding('module_wrap');`

## node:internal/modules/esm/worker (x1):
- Line 253: `    internalBinding('errors').triggerUncaughtException(`

## node:internal/navigator (x1):
- Line 27: `} = internalBinding('os');`

## node:internal/process/report (x1):
- Line 17: `const nr = internalBinding('report');`

## node:internal/source_map/prepare_stack_trace (x1):
- Line 25: `const { setGetSourceMapErrorSource } = internalBinding('errors');`

## node:internal/source_map/source_map_cache_map (x1):
- Line 15: `} = internalBinding('util');`

## node:internal/test_runner/coverage (x1):
- Line 125: `    internalBinding('profiler').takeCoverage();`

## node:internal/test_runner/reporter/tap (x1):
- Line 167: `    if (internalBinding('types').isDate(value)) {`

## node:internal/trace_events_async_hooks (x2):
- Line 10: `const { trace } = internalBinding('trace_events');`
- Line 11: `const async_wrap = internalBinding('async_wrap');`

## node:internal/util/comparisons (x2):
- Line 28: `const { compare } = internalBinding('buffer');`
- Line 56: `} = internalBinding('util');`

## node:internal/util/embedding (x1):
- Line 7: `const { getCodePath, isSea } = internalBinding('sea');`

## node:internal/v8_prof_processor (x1):
- Line 15: `const { natives } = internalBinding('builtins');`

## node:internal/vm/module (x1):
- Line 55: `const binding = internalBinding('module_wrap');`

## node:internal/watchdog (x1):
- Line 5: `} = internalBinding('watchdog');`

## node:internal/webstreams/transfer (x1):
- Line 16: `} = internalBinding('messaging');`

##  (x0):
- Line : ``
