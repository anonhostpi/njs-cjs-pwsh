# All InternalBinding Calls by Binding:

## 'inspector' (x7):
- node:internal/bootstrap/web/exposed-wildcard:68: `const { setConsoleExtensionInstaller } = internalBinding('inspector');`
- node:internal/console/constructor:654: `  const { console: consoleFromVM } = internalBinding('inspector');`
- node:internal/util/inspector:85: `  const { consoleCall, console: consoleFromVM } = internalBinding('inspector');`
- node:internal/modules/cjs/loader:1444: `      inspectorWrapper = internalBinding('inspector').callAndPauseOnStart;`
- node:internal/process/pre_execution:483: `    internalBinding('inspector').registerAsyncHook(enable, disable);`
- node:internal/inspector_async_hook:11: `  const inspector = internalBinding('inspector');`
- node:inspector:45: `} = internalBinding('inspector');`

## 'spawn_sync' (x1):
- node:internal/child_process:61: `const spawn_sync = internalBinding('spawn_sync');`

## 'process_methods' (x9):
- node:internal/bootstrap/node:158: `const rawMethods = internalBinding('process_methods');`
- node:internal/bootstrap/node:303: `internalBinding('process_methods').setEmitWarningSync(emitWarningSync);`
- node:internal/process/per_thread:60: `const binding = internalBinding('process_methods');`
- node:internal/bootstrap/switches/is_main_thread:7: `const rawMethods = internalBinding('process_methods');`
- node:internal/process/pre_execution:219: `  const binding = internalBinding('process_methods');`
- node:internal/bootstrap/switches/does_own_process_state:4: `const rawMethods = internalBinding('process_methods');`
- node:inspector:35: `const { _debugEnd } = internalBinding('process_methods');`
- node:internal/bootstrap/node:158: `const rawMethods = internalBinding('process_methods');`
- node:internal/bootstrap/node:303: `internalBinding('process_methods').setEmitWarningSync(emitWarningSync);`

## 'types' (x2):
- node:internal/util:67: `const { isNativeError, isPromise } = internalBinding('types');`
- node:internal/util/types:58: `  ...internalBinding('types'),`

## 'fs' (x8):
- node:fs:65: `const binding = internalBinding('fs');`
- node:internal/modules/cjs/loader:142: `const { internalModuleStat } = internalBinding('fs');`
- node:internal/net:10: `const { writeBuffer } = internalBinding('fs');`
- node:internal/fs/promises:32: `const binding = internalBinding('fs');`
- node:internal/fs/dir:13: `const binding = internalBinding('fs');`
- node:internal/fs/watchers:25: `} = internalBinding('fs');`
- node:internal/http2/core:187: `const { FileHandle } = internalBinding('fs');`
- node:internal/modules/esm/formats:10: `const fsBindings = internalBinding('fs');`

## 'http2' (x3):
- node:internal/http2/core:188: `const binding = internalBinding('http2');`
- node:internal/http2/compat:39: `} = internalBinding('http2');`
- node:internal/http2/util:21: `const binding = internalBinding('http2');`

## 'profiler' (x3):
- node:internal/util:831: `    internalBinding('profiler').setCoverageDirectory(coverageDirectory);`
- node:internal/util:832: `    internalBinding('profiler').setSourceMapCacheGetter(sourceMapCacheToObject);`
- node:v8:48: `  profiler = internalBinding('profiler');`

## 'modules' (x2):
- node:internal/modules/package_json_reader:10: `const modulesBinding = internalBinding('modules');`
- node:internal/modules/run_main:8: `const { getNearestParentPackageJSONType } = internalBinding('modules');`

## 'js_stream' (x1):
- node:internal/js_stream_socket:10: `const { JSStream } = internalBinding('js_stream');`

## 'blob' (x2):
- node:internal/url:1173: `  const bindingBlob = internalBinding('blob');`
- node:internal/blob:27: `} = internalBinding('blob');`

## 'trace_events' (x7):
- node:internal/bootstrap/node:222: `const { setTraceCategoryStateUpdateHandler } = internalBinding('trace_events');`
- node:internal/util/debuglog:23: `const { isTraceCategoryEnabled, trace } = internalBinding('trace_events');`
- node:internal/console/constructor:37: `const { trace } = internalBinding('trace_events');`
- node:internal/process/pre_execution:467: `  const { isTraceCategoryEnabled } = internalBinding('trace_events');`
- node:internal/http:11: `const { trace, isTraceCategoryEnabled } = internalBinding('trace_events');`
- node:trace_events:21: `const { CategorySet, getEnabledCategories } = internalBinding('trace_events');`
- node:internal/bootstrap/node:222: `const { setTraceCategoryStateUpdateHandler } = internalBinding('trace_events');`

## 'symbols' (x12):
- node:internal/async_hooks:84: `const { resource_symbol, owner_symbol } = internalBinding('symbols');`
- node:internal/async_hooks:96: `        trigger_async_id_symbol } = internalBinding('symbols');`
- node:internal/worker/js_transferable:11: `} = internalBinding('symbols');`
- node:internal/vm:20: `} = internalBinding('symbols');`
- node:internal/modules/cjs/loader:160: `} = internalBinding('symbols');`
- node:internal/modules/esm/utils:21: `} = internalBinding('symbols');`
- node:internal/process/pre_execution:82: `  } = internalBinding('symbols');`
- node:vm:68: `} = internalBinding('symbols');`
- node:internal/modules/esm/loader:22: `const { imported_cjs_symbol } = internalBinding('symbols');`
- node:_tls_wrap:88: `const { onpskexchange: kOnPskExchange } = internalBinding('symbols');`
- node:internal/worker/io:31: `} = internalBinding('symbols');`
- node:internal/blocklist:31: `const { owner_symbol } = internalBinding('symbols');`

## 'async_wrap' (x4):
- node:internal/bootstrap/node:208: `internalBinding('async_wrap').setupHooks(nativeHooks);`
- node:internal/async_hooks:13: `const async_wrap = internalBinding('async_wrap');`
- node:internal/promise_hooks:11: `const { setPromiseHooks } = internalBinding('async_wrap');`
- node:internal/bootstrap/node:208: `internalBinding('async_wrap').setupHooks(nativeHooks);`

##  (x1):
- node:internal/bootstrap/realm:177: ` * Set up internalBinding() in the closure.`

## 'wasm_web_api' (x2):
- node:internal/bootstrap/web/exposed-window-or-worker:90: `internalBinding('wasm_web_api').setImplementation((streamState, source) => {`
- node:internal/bootstrap/switches/is_main_thread:308: `internalBinding('wasm_web_api');`

## 'builtins' (x3):
- node:internal/bootstrap/realm:199: `} = internalBinding('builtins');`
- node:internal/bootstrap/node:138: `const binding = internalBinding('builtins');`
- node:internal/bootstrap/node:138: `const binding = internalBinding('builtins');`

## 'permission' (x1):
- node:internal/process/permission:8: `const permission = internalBinding('permission');`

## id (x2):
- node:internal/test/binding:13: `function filteredInternalBinding(id) {`
- node:internal/test/binding:25: `  return internalBinding(id);`

## 'cares_wrap' (x5):
- node:internal/dns/utils:31: `  binding ??= internalBinding('cares_wrap');`
- node:tls:65: `const { canonicalizeIP } = internalBinding('cares_wrap');`
- node:dns:30: `const cares = internalBinding('cares_wrap');`
- node:internal/dns/callback_resolver:29: `} = internalBinding('cares_wrap');`
- node:internal/dns/promises:65: `} = internalBinding('cares_wrap');`

## 'signal_wrap' (x1):
- node:internal/process/signal:25: `      Signal = internalBinding('signal_wrap').Signal;`

## 'tcp_wrap' (x4):
- node:net:72: `} = internalBinding('tcp_wrap');`
- node:_tls_wrap:63: `const { TCP, constants: TCPConstants } = internalBinding('tcp_wrap');`
- node:internal/child_process:54: `const { TCP } = internalBinding('tcp_wrap');`
- node:internal/cluster/round_robin_handle:13: `const { constants } = internalBinding('tcp_wrap');`

## 'process_wrap' (x1):
- node:internal/child_process:45: `const { Process } = internalBinding('process_wrap');`

## 'serdes' (x1):
- node:v8:41: `} = internalBinding('serdes');`

## 'crypto' (x18):
- node:_tls_common:72: `} = internalBinding('crypto');`
- node:tls:63: `const { getRootCertificates, getSSLCiphers } = internalBinding('crypto');`
- node:_tls_wrap:68: `const { SecureContext: NativeSecureContext } = internalBinding('crypto');`
- node:crypto:48: `} = internalBinding('crypto');`
- node:internal/crypto/random:31: `} = internalBinding('crypto');`
- node:internal/crypto/pbkdf2:13: `} = internalBinding('crypto');`
- node:internal/crypto/util:33: `} = internalBinding('crypto');`
- node:internal/crypto/scrypt:13: `} = internalBinding('crypto');`
- node:internal/crypto/hkdf:11: `} = internalBinding('crypto');`
- node:internal/crypto/keys:27: `} = internalBinding('crypto');`
- node:internal/crypto/keygen:26: `} = internalBinding('crypto');`
- node:internal/crypto/diffiehellman:20: `} = internalBinding('crypto');`
- node:internal/crypto/cipher:16: `} = internalBinding('crypto');`
- node:internal/crypto/sig:33: `} = internalBinding('crypto');`
- node:internal/crypto/hash:16: `} = internalBinding('crypto');`
- node:internal/crypto/x509:17: `} = internalBinding('crypto');`
- node:internal/crypto/certificate:7: `} = internalBinding('crypto');`
- node:internal/crypto/webcrypto:22: `} = internalBinding('crypto');`

## 'url' (x4):
- node:internal/url:91: `const bindingUrl = internalBinding('url');`
- node:internal/modules/helpers:30: `const { canParse: URLCanParse } = internalBinding('url');`
- node:url:63: `const bindingUrl = internalBinding('url');`
- node:internal/modules/esm/loader:39: `const { canParse } = internalBinding('url');`

## 'uv' (x10):
- node:internal/errors:617: `uvBinding ??= internalBinding('uv');`
- node:internal/util:80: `uvBinding ??= internalBinding('uv');`
- node:net:64: `} = internalBinding('uv');`
- node:internal/stream_base_commons:18: `const { UV_EOF } = internalBinding('uv');`
- node:internal/js_stream_socket:11: `const uv = internalBinding('uv');`
- node:internal/child_process:75: `} = internalBinding('uv');`
- node:internal/dgram:17: `const { UV_EINVAL } = internalBinding('uv');`
- node:internal/fs/watchers:28: `const { UV_ENOSPC } = internalBinding('uv');`
- node:internal/http2/core:194: `const { UV_EOF } = internalBinding('uv');`
- node:internal/webstreams/adapters:88: `const { UV_EOF } = internalBinding('uv');`

## 'performance' (x8):
- node:internal/perf/utils:10: `} = internalBinding('performance');`
- node:internal/process/pre_execution:702: `  internalBinding('performance').markBootstrapComplete();`
- node:internal/perf/observe:36: `} = internalBinding('performance');`
- node:internal/perf/event_loop_utilization:9: `} = internalBinding('performance');`
- node:perf_hooks:9: `} = internalBinding('performance');`
- node:internal/perf/nodetiming:31: `} = internalBinding('performance');`
- node:internal/histogram:15: `} = internalBinding('performance');`
- node:internal/perf/event_loop_delay:17: `} = internalBinding('performance');`

## 'task_queue' (x3):
- node:internal/async_hooks:83: `const { enqueueMicrotask } = internalBinding('task_queue');`
- node:internal/process/task_queues:16: `} = internalBinding('task_queue');`
- node:internal/process/promises:21: `} = internalBinding('task_queue');`

## 'stream_pipe' (x1):
- node:internal/http2/core:196: `const { StreamPipe } = internalBinding('stream_pipe');`

## 'http_parser' (x2):
- node:_http_common:31: `const { methods, allMethods, HTTPParser } = internalBinding('http_parser');`
- node:_http_server:52: `const { ConnectionsList } = internalBinding('http_parser');`

## 'fs_event_wrap' (x1):
- node:internal/fs/watchers:27: `const { FSEvent } = internalBinding('fs_event_wrap');`

## 'tls_wrap' (x1):
- node:_tls_wrap:64: `const tls_wrap = internalBinding('tls_wrap');`

## 'errors' (x11):
- node:internal/bootstrap/realm:447: `  } = internalBinding('errors');`
- node:internal/bootstrap/node:338: `  } = internalBinding('errors');`
- node:internal/async_hooks:11: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`
- node:internal/process/per_thread:58: `const { exitCodes: { kNoFailure } } = internalBinding('errors');`
- node:internal/process/promises:29: `} = internalBinding('errors');`
- node:internal/process/execution:19: `const { exitCodes: { kGenericUserError } } = internalBinding('errors');`
- node:internal/source_map/source_map_cache:21: `} = internalBinding('errors');`
- node:internal/modules/run_main:18: `} = internalBinding('errors');`
- node:diagnostics_channel:30: `const { triggerUncaughtException } = internalBinding('errors');`
- node:internal/promise_hooks:12: `const { triggerUncaughtException } = internalBinding('errors');`
- node:internal/bootstrap/node:338: `  } = internalBinding('errors');`

## 'pipe_wrap' (x4):
- node:net:77: `} = internalBinding('pipe_wrap');`
- node:_tls_wrap:65: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`
- node:child_process:63: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`
- node:internal/child_process:53: `const { Pipe, constants: PipeConstants } = internalBinding('pipe_wrap');`

## 'stream_wrap' (x5):
- node:net:67: `const { ShutdownWrap } = internalBinding('stream_wrap');`
- node:internal/stream_base_commons:17: `} = internalBinding('stream_wrap');`
- node:internal/child_process:52: `} = internalBinding('stream_wrap');`
- node:internal/http2/core:193: `} = internalBinding('stream_wrap');`
- node:internal/webstreams/adapters:84: `} = internalBinding('stream_wrap');`

## 'contextify' (x5):
- node:internal/process/execution:30: `const { containsModuleSyntax } = internalBinding('contextify');`
- node:internal/vm:11: `} = internalBinding('contextify');`
- node:internal/modules/cjs/loader:137: `} = internalBinding('contextify');`
- node:vm:37: `} = internalBinding('contextify');`
- node:repl:185: `} = internalBinding('contextify');`

## 'heap_utils' (x1):
- node:v8:60: `} = internalBinding('heap_utils');`

## 'config' (x16):
- node:internal/bootstrap/node:68: `const config = internalBinding('config');`
- node:internal/util/inspect:2323: `if (internalBinding('config').hasIntl) {`
- node:buffer:1216: `if (internalBinding('config').hasIntl) {`
- node:internal/encoding:390: `  internalBinding('config').hasIntl ?`
- node:internal/bootstrap/web/exposed-wildcard:20: `const config = internalBinding('config');`
- node:internal/console/constructor:651: `  if (!internalBinding('config').hasInspector || !isBuildingSnapshot()) {`
- node:internal/util/inspector:49: `  const { hasInspector } = internalBinding('config');`
- node:internal/bootstrap/switches/is_main_thread:304: `if (internalBinding('config').hasInspector) {`
- node:internal/process/pre_execution:353: `  if (internalBinding('config').hasOpenSSL) {`
- node:internal/process/pre_execution:478: `  if (internalBinding('config').hasInspector) {`
- node:internal/process/pre_execution:529: `  const { noBrowserGlobals } = internalBinding('config');`
- node:internal/inspector_async_hook:13: `  config = internalBinding('config');`
- node:inspector:21: `const { hasInspector } = internalBinding('config');`
- node:trace_events:8: `const { hasTracing } = internalBinding('config');`
- node:v8:47: `if (internalBinding('config').hasInspector) {`
- node:internal/bootstrap/node:68: `const config = internalBinding('config');`

## 'fs_dir' (x1):
- node:internal/fs/dir:14: `const dirBinding = internalBinding('fs_dir');`

## 'icu' (x3):
- node:internal/util/inspect:2324: `  const icu = internalBinding('icu');`
- node:buffer:1220: `  } = internalBinding('icu');`
- node:internal/encoding:398: `  } = internalBinding('icu');`

## 'mksnapshot' (x2):
- node:internal/v8/startup_snapshot:19: `} = internalBinding('mksnapshot');`
- node:internal/process/pre_execution:685: `  internalBinding('mksnapshot').runEmbedderPreload(process, require);`

## 'worker' (x6):
- node:internal/bootstrap/switches/is_main_thread:310: `internalBinding('worker');`
- node:internal/process/pre_execution:127: `    assert(internalBinding('worker').isMainThread);`
- node:internal/process/pre_execution:148: `    assert(!internalBinding('worker').isMainThread);`
- node:internal/process/pre_execution:724: `  const threadId = internalBinding('worker').threadId;`
- node:internal/worker:77: `} = internalBinding('worker');`
- node:internal/worker/io:44: `} = internalBinding('worker');`

## 'messaging' (x11):
- node:internal/util:698: `  _DOMException ??= internalBinding('messaging').DOMException;`
- node:internal/util:703: `  _DOMException ??= internalBinding('messaging').DOMException;`
- node:internal/worker/js_transferable:14: `} = internalBinding('messaging');`
- node:internal/bootstrap/web/exposed-window-or-worker:35: `const { structuredClone } = internalBinding('messaging');`
- node:internal/abort_controller:53: `} = internalBinding('messaging');`
- node:internal/worker/io:41: `} = internalBinding('messaging');`
- node:internal/perf/usertiming:34: `const { structuredClone } = internalBinding('messaging');`
- node:internal/webstreams/transformstream:23: `} = internalBinding('messaging');`
- node:internal/webstreams/readablestream:43: `} = internalBinding('messaging');`
- node:internal/webstreams/readablestream:90: `const { structuredClone } = internalBinding('messaging');`
- node:internal/webstreams/writablestream:30: `} = internalBinding('messaging');`

## 'util' (x19):
- node:internal/errors:939: `} = internalBinding('util');`
- node:internal/bootstrap/node:86: `} = internalBinding('util');`
- node:internal/util:66: `} = internalBinding('util');`
- node:internal/util/inspect:112: `} = internalBinding('util');`
- node:buffer:80: `} = internalBinding('util');`
- node:internal/buffer:40: `} = internalBinding('util');`
- node:internal/worker/js_transferable:24: `} = internalBinding('util');`
- node:internal/process/execution:37: `const { shouldAbortOnUncaughtToggle } = internalBinding('util');`
- node:internal/vm:32: `} = internalBinding('util');`
- node:internal/webstreams/util:41: `} = internalBinding('util');`
- node:util:75: `const binding = internalBinding('util');`
- node:internal/console/constructor:51: `const { previewEntries } = internalBinding('util');`
- node:internal/modules/cjs/loader:72: `} = internalBinding('util');`
- node:internal/modules/esm/utils:14: `} = internalBinding('util');`
- node:internal/process/pre_execution:79: `  } = internalBinding('util');`
- node:internal/process/pre_execution:496: `  const utilBinding = internalBinding('util');`
- node:internal/modules/run_main:23: `} = internalBinding('util');`
- node:repl:181: `} = internalBinding('util');`
- node:internal/bootstrap/node:86: `} = internalBinding('util');`

## 'constants' (x19):
- node:internal/validators:37: `const { signals } = internalBinding('constants').os;`
- node:internal/util:57: `const { signals } = internalBinding('constants').os;`
- node:internal/process/per_thread:51: `const constants = internalBinding('constants').os.signals;`
- node:internal/fs/utils:109: `} = internalBinding('constants');`
- node:fs:46: `const { fs: constants } = internalBinding('constants');`
- node:internal/process/signal:12: `const { signals } = internalBinding('constants').os;`
- node:_tls_common:47: `} = internalBinding('constants');`
- node:crypto:42: `const constants = internalBinding('constants').crypto;`
- node:internal/crypto/util:41: `} = internalBinding('constants');`
- node:internal/crypto/diffiehellman:66: `} = internalBinding('constants');`
- node:internal/crypto/cipher:23: `} = internalBinding('constants');`
- node:internal/tls/secure-context:44: `} = internalBinding('constants');`
- node:dgram:74: `const { UV_UDP_REUSEADDR } = internalBinding('constants').os;`
- node:constants:33: `const constants = internalBinding('constants');`
- node:internal/fs/promises:23: `const { fs: constants } = internalBinding('constants');`
- node:os:35: `const constants = internalBinding('constants').os;`
- node:internal/modules/esm/formats:11: `const { fs: fsConstants } = internalBinding('constants');`
- node:internal/webstreams/adapters:96: `      ObjectEntries(internalBinding('constants').zlib),`
- node:zlib:82: `const constants = internalBinding('constants').zlib;`

## 'wasi' (x2):
- node:wasi:54: `        ({ WASI: _WASI } = internalBinding('wasi'));`
- node:wasi:58: `        ({ WASI: _WASI } = internalBinding('wasi'));`

## 'internal_only_v8' (x1):
- node:internal/heap_utils:26: `} = internalBinding('internal_only_v8');`

## 'udp_wrap' (x3):
- node:internal/child_process:56: `const { UDP } = internalBinding('udp_wrap');`
- node:dgram:80: `} = internalBinding('udp_wrap');`
- node:internal/dgram:11: `const { UDP } = internalBinding('udp_wrap');`

## module (x4):
- node:internal/bootstrap/realm:155: `      return internalBinding(module);`
- node:internal/bootstrap/realm:161: `      return internalBinding(module);`
- node:internal/bootstrap/realm:184: `  internalBinding = function internalBinding(module) {`
- node:internal/bootstrap/realm:187: `      mod = bindingObj[module] = getInternalBinding(module);`

## 'module_wrap' (x6):
- node:internal/bootstrap/realm:201: `const { ModuleWrap } = internalBinding('module_wrap');`
- node:internal/bootstrap/switches/is_main_thread:297: `internalBinding('module_wrap');`
- node:internal/modules/cjs/loader:74: `const { kEvaluated } = internalBinding('module_wrap');`
- node:internal/modules/esm/utils:23: `const { ModuleWrap } = internalBinding('module_wrap');`
- node:internal/modules/esm/utils:45: `} = internalBinding('module_wrap');`
- node:internal/modules/esm/loader:40: `const { ModuleWrap, kEvaluating, kEvaluated } = internalBinding('module_wrap');`

## 'zlib' (x1):
- node:zlib:65: `const binding = internalBinding('zlib');`

## 'timers' (x4):
- node:internal/bootstrap/node:317: `  const { setupTimers } = internalBinding('timers');`
- node:internal/timers:84: `const binding = internalBinding('timers');`
- node:timers:32: `const binding = internalBinding('timers');`
- node:internal/bootstrap/node:317: `  const { setupTimers } = internalBinding('timers');`

## 'sea' (x1):
- node:internal/modules/cjs/loader:1381: `      internalBinding('sea').isSea()) {`

## 'block_list' (x2):
- node:internal/blocklist:11: `} = internalBinding('block_list');`
- node:internal/socketaddress:12: `} = internalBinding('block_list');`

## 'string_decoder' (x2):
- node:internal/util:69: `const { encodings } = internalBinding('string_decoder');`
- node:string_decoder:41: `} = internalBinding('string_decoder');`

## 'os' (x2):
- node:internal/errors:909: `      const info = internalBinding('os').getOSInformation();`
- node:os:61: `} = internalBinding('os');`

## 'buffer' (x7):
- node:internal/bootstrap/node:405: `  const bufferBinding = internalBinding('buffer');`
- node:buffer:73: `} = internalBinding('buffer');`
- node:internal/buffer:34: `} = internalBinding('buffer');`
- node:internal/blob:30: `} = internalBinding('buffer');`
- node:internal/webstreams/util:30: `} = internalBinding('buffer');`
- node:v8:52: `const { copy } = internalBinding('buffer');`
- node:internal/bootstrap/node:405: `  const bufferBinding = internalBinding('buffer');`

## 'options' (x2):
- node:internal/options:7: `} = internalBinding('options');`
- node:internal/process/per_thread:286: `  } = internalBinding('options');`

## 'encoding_binding' (x1):
- node:internal/encoding:52: `const binding = internalBinding('encoding_binding');`

## 'v8' (x1):
- node:v8:105: `const binding = internalBinding('v8');`

## 'credentials' (x5):
- node:internal/bootstrap/node:194: `const credentials = internalBinding('credentials');`
- node:internal/modules/cjs/loader:143: `const { safeGetenv } = internalBinding('credentials');`
- node:internal/bootstrap/switches/does_own_process_state:3: `const credentials = internalBinding('credentials');`
- node:os:34: `const { safeGetenv } = internalBinding('credentials');`
- node:internal/bootstrap/node:194: `const credentials = internalBinding('credentials');`

## 'tty_wrap' (x2):
- node:internal/child_process:55: `const { TTY } = internalBinding('tty_wrap');`
- node:tty:31: `const { TTY, isTTY } = internalBinding('tty_wrap');`
