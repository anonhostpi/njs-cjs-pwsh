'use strict';
const {
  ArrayPrototypeJoin,
  ArrayPrototypeMap,
  ArrayPrototypeSlice,
  ArrayPrototypeSort,
  JSONStringify,
  ObjectKeys,
  SafeMap,
  String,
  StringPrototypeReplaceAll,
} = primordials;
const {
  codes: {
    ERR_INVALID_STATE,
  },
} = require('internal/errors');
const { emitExperimentalWarning, kEmptyObject } = require('internal/util');
let debug = require('internal/util/debuglog').debuglog('test_runner', (fn) => {
  debug = fn;
});
const {
  validateArray,
  validateFunction,
  validateObject,
} = require('internal/validators');
const { strictEqual } = require('assert');
const { mkdirSync, readFileSync, writeFileSync } = require('fs');
const { dirname } = require('path');
const { createContext, runInContext } = require('vm');
const kExperimentalWarning = 'Snapshot testing';
const kMissingSnapshotTip = 'Missing snapshots can be generated by rerunning ' +
  'the command with the --test-update-snapshots flag.';
const defaultSerializers = [
  (value) => { return JSONStringify(value, null, 2); },
];

function defaultResolveSnapshotPath(testPath) {
  if (typeof testPath !== 'string') {
    return testPath;
  }

  return `${testPath}.snapshot`;
}

let resolveSnapshotPathFn = defaultResolveSnapshotPath;
let serializerFns = defaultSerializers;

function setResolveSnapshotPath(fn) {
  emitExperimentalWarning(kExperimentalWarning);
  validateFunction(fn, 'fn');
  resolveSnapshotPathFn = fn;
}

function setDefaultSnapshotSerializers(serializers) {
  emitExperimentalWarning(kExperimentalWarning);
  validateFunctionArray(serializers, 'serializers');
  serializerFns = ArrayPrototypeSlice(serializers);
}

class SnapshotManager {
  constructor(entryFile, updateSnapshots) {
    this.entryFile = entryFile;
    this.snapshotFile = undefined;
    this.snapshots = { __proto__: null };
    this.nameCounts = new SafeMap();
    // A manager instance will only read or write snapshot files based on the
    // updateSnapshots argument.
    this.loaded = updateSnapshots;
    this.updateSnapshots = updateSnapshots;
  }

  resolveSnapshotFile() {
    if (this.snapshotFile === undefined) {
      const resolved = resolveSnapshotPathFn(this.entryFile);

      if (typeof resolved !== 'string') {
        const err = new ERR_INVALID_STATE('Invalid snapshot filename.');
        err.filename = resolved;
        throw err;
      }

      this.snapshotFile = resolved;
    }
  }

  serialize(input, serializers = serializerFns) {
    try {
      let value = input;

      for (let i = 0; i < serializers.length; ++i) {
        const fn = serializers[i];
        value = fn(value);
      }

      return `\n${templateEscape(value)}\n`;
    } catch (err) {
      const error = new ERR_INVALID_STATE(
        'The provided serializers did not generate a string.',
      );
      error.input = input;
      error.cause = err;
      throw error;
    }
  }

  getSnapshot(id) {
    if (!(id in this.snapshots)) {
      const err = new ERR_INVALID_STATE(`Snapshot '${id}' not found in ` +
        `'${this.snapshotFile}.' ${kMissingSnapshotTip}`);
      err.snapshot = id;
      err.filename = this.snapshotFile;
      throw err;
    }

    return this.snapshots[id];
  }

  setSnapshot(id, value) {
    this.snapshots[templateEscape(id)] = value;
  }

  nextId(name) {
    const count = this.nameCounts.get(name) ?? 1;

    this.nameCounts.set(name, count + 1);
    return `${name} ${count}`;
  }

  readSnapshotFile() {
    if (this.loaded) {
      debug('skipping read of snapshot file');
      return;
    }

    try {
      const source = readFileSync(this.snapshotFile, 'utf8');
      const context = { __proto__: null, exports: { __proto__: null } };

      createContext(context);
      runInContext(source, context);

      if (context.exports === null || typeof context.exports !== 'object') {
        throw new ERR_INVALID_STATE(
          `Malformed snapshot file '${this.snapshotFile}'.`,
        );
      }

      this.snapshots = context.exports;
      this.loaded = true;
    } catch (err) {
      let msg = `Cannot read snapshot file '${this.snapshotFile}.'`;

      if (err?.code === 'ENOENT') {
        msg += ` ${kMissingSnapshotTip}`;
      }

      const error = new ERR_INVALID_STATE(msg);
      error.cause = err;
      error.filename = this.snapshotFile;
      throw error;
    }
  }

  writeSnapshotFile() {
    if (!this.updateSnapshots) {
      debug('skipping write of snapshot file');
      return;
    }

    try {
      const keys = ArrayPrototypeSort(ObjectKeys(this.snapshots));
      const snapshotStrings = ArrayPrototypeMap(keys, (key) => {
        return `exports[\`${key}\`] = \`${this.snapshots[key]}\`;\n`;
      });
      const output = ArrayPrototypeJoin(snapshotStrings, '\n');
      mkdirSync(dirname(this.snapshotFile), { __proto__: null, recursive: true });
      writeFileSync(this.snapshotFile, output, 'utf8');
    } catch (err) {
      const msg = `Cannot write snapshot file '${this.snapshotFile}.'`;
      const error = new ERR_INVALID_STATE(msg);
      error.cause = err;
      error.filename = this.snapshotFile;
      throw error;
    }
  }

  createAssert() {
    const manager = this;

    return function snapshotAssertion(actual, options = kEmptyObject) {
      emitExperimentalWarning(kExperimentalWarning);
      // Resolve the snapshot file here so that any resolution errors are
      // surfaced as early as possible.
      manager.resolveSnapshotFile();

      const { fullName } = this;
      const id = manager.nextId(fullName);

      validateObject(options, 'options');

      const {
        serializers = serializerFns,
      } = options;

      validateFunctionArray(serializers, 'options.serializers');

      const value = manager.serialize(actual, serializers);

      if (manager.updateSnapshots) {
        manager.setSnapshot(id, value);
      } else {
        manager.readSnapshotFile();
        strictEqual(value, manager.getSnapshot(id));
      }
    };
  }
}

function validateFunctionArray(fns, name) {
  validateArray(fns, name);
  for (let i = 0; i < fns.length; ++i) {
    validateFunction(fns[i], `${name}[${i}]`);
  }
}

function templateEscape(str) {
  let result = String(str);
  result = StringPrototypeReplaceAll(result, '\\', '\\\\');
  result = StringPrototypeReplaceAll(result, '`', '\\`');
  result = StringPrototypeReplaceAll(result, '${', '\\${');
  return result;
}

module.exports = {
  SnapshotManager,
  defaultResolveSnapshotPath, // Exported for testing only.
  defaultSerializers,         // Exported for testing only.
  setDefaultSnapshotSerializers,
  setResolveSnapshotPath,
};

