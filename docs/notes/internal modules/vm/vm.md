# Notes about modules:

Modules are run in the same "VM" as the main script, but in an isolated context.

# Isolated VMs vs Isolated Contexts:

The main difference between an isolated VM and an isolated context is that an isolated VM has its own global object, while an isolated context shares the global object with the main script. (global => globalThis (previously window and global))

# Structure (vm.js):

- Constants:
    - from `primordials`:
        - `ArrayPrototypeForEach`
        - `ObjectFreeze`
        - `PromiseReject`
        - `ReflectApply`
        - `Symbol`
    - from `internalBinding()`:
        - `contextift` binding:
            - `ContextifyScript`
            - `makeContext`
            - `constants`
            - `measureMemory` (`_measureMemory`)
        - `symbols` binding:
            - `vm_dynamic_import_main_context_default`
    - from `require()`:
        - `internal/____` modules:
            - `errors` module:
                - `ERR_CONTEXT_NOT_INITIALIZED`
                - `ERR_INVALID_ARG_TYPE`
            - `validators` module:
                - `validateArray`
                - `validateBoolean`
                - `validateBuffer`
                - `validateInt32`
                - `validateOneOf`
                - `validateObject`
                - `validateString`
                - `validateStringArray`
                - `validateUint32`
                - `kValidateObjectAllowArray`
                - `kValidateObjectAllowNullable`
            - `util` module:
                - `emitExperimentalWarning`
                - `kEmptyObject`
                - `kVmBreakFirstLineSymbol`
            - `vm` module:
                - `getHostDefinedOptionId`
                - `internalCompileFunction`
                - `isContext` (`_isContext`)
                - `registerImportModuleDynamically`
    - others:
```js
const kParsingContext = Symbol('script parsing context');

const measureMemoryModes = {
  summary: constants.measureMemory.mode.SUMMARY,
  detailed: constants.measureMemory.mode.DETAILED,
};

const measureMemoryExecutions = {
  default: constants.measureMemory.execution.DEFAULT,
  eager: constants.measureMemory.execution.EAGER,
};

const vmConstants = {
  __proto__: null,
  USE_MAIN_CONTEXT_DEFAULT_LOADER: vm_dynamic_import_main_context_default,
};

ObjectFreeze(vmConstants);
```
- Functions:
    - `isContext(object)`
    - `validateContext(contextifiedObject)`
    - `getRunInContextArgs(contextifiedObject, options = kEmptyObject)`
    - `getContextOptions(options)`
    - `createContext(contextObject = {}, options = kEmptyObject)`
    - `createScript(code, options)`
    - `sigintHandlersWrap(fn, thisArg, argsArray)`
    - `runInContext(code, contextifiedObject, options)`
    - `runInNewContext(code, contextObject, options)`
    - `runInThisContext(code, options)`
    - `compileFunction(code, params, options = kEmptyObject)`
    - `measureMemory(options = kEmptyObject)`

- Classes:
    - `Script` extends `ContextifyScript`

- Exorts:
```js
module.exports = {
  Script,
  createContext,
  createScript,
  runInContext,
  runInNewContext,
  runInThisContext,
  isContext,
  compileFunction,
  measureMemory,
  constants: vmConstants,
};
```

            