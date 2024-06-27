const imports = {
    primordials : {},
    internalBindings : {},
    require : { internals : {} }
}

{
    const {
        ArrayPrototypeForEach,
        ObjectFreeze,
        ReflectApply,
        Symbol
    } = primordials
    imports.primordials = {
        ArrayPrototypeForEach,
        ObjectFreeze,
        ReflectApply,
        Symbol
    }

    const {
        ContextifyScript,
        makeContext,
        constants,
        measureMemory: _measureMemory
    } = internalBinding( 'contextify' )
    imports.internalBindings = {
        contextify : {
            ContextifyScript,
            makeContext,
            constants,
            measureMemory
        }
    }

    const {
        vm_dynamic_import_main_context_default
    } = internalBinding( 'symbols' )
    imports.internalBindings.symbols = {
        vm_dynamic_import_main_context_default
    }

    const {
        ERR_CONTEXT_NOT_INITIALIZED,
        ERR_INVALID_ARG_TYPE
    } = require('internal/errors')
    imports.require.internals.errors = {
        ERR_CONTEXT_NOT_INITIALIZED,
        ERR_INVALID_ARG_TYPE
    }

    const {
        validateArray,
        validateBoolean,
        validateBuffer,
        validateInt32,
        validateOneOf,
        validateObject,
        validateString,
        validateStringArray,
        validateUint32,
        kValidateObjectAllowArray,
        kValidateObjectAllowNullable
    } = require('internal/validators')
    imports.require.internals.validators = {
        validateArray,
        validateBoolean,
        validateBuffer,
        validateInt32,
        validateOneOf,
        validateObject,
        validateString,
        validateStringArray,
        validateUint32,
        kValidateObjectAllowArray,
        kValidateObjectAllowNullable
    }

    const {
        emitExperimentalWarning,
        kEmptyObject,
        kVmBreakFirstLineSymbol
    } = require('internal/util')
    imports.require.internals.util = {
        emitExperimentalWarning,
        kEmptyObject,
        kVmBreakFirstLineSymbol
    }

    const {
        getHostDefinedOptionId,
        internalCompileFunction,
        isContext: _isContext,
        registerImportModuleDynamically
    } = require('internal/vm')
    imports.require.internals.vm = {
        getHostDefinedOptionId,
        internalCompileFunction,
        isContext,
        registerImportModuleDynamically
    }
};

const constants = {}

{
    constants.kParsingContext = Symbol('script parsing context')
    
    const _measureMemory = imports.internalBindings.contextify.measureMemory
    constants.measureMemoryModes = {
        summary: _measureMemory.mode.SUMMARY,
        detailed: _measureMemory.mode.DETAILED
    }
    constants.measureMemoryExecution = {
        default: _measureMemory.execution.DEFAULT,
        eager: _measureMemory.execution.EAGER
    }

    const _symbols = imports.internalBindings.symbols
    constants.vmConstants = {
        __proto__: null,
        USE_MAIN_CONTEXT_DEFAULT_LOADER: _symbols.vm_dynamic_import_main_context_default
    }
}