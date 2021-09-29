# Release Notes

All notable changes to this project will be documented in this file.

## [0.1.0] – 2021-09-27

### Improvements

- ton-labs-node dependency is fixed to `f9e9a99ab989a4e88017630931c7475f14e9d46c`
- Not-indexed arangodb was removed, now all queries, fast and slow are executed on the same arangodb.
- Increased memlimit for Rust Node
- Changed default Rust Node log config
  
### Fixed

- ton-labs-node: Fixed possible error while block broadcast's checking  (after node's restart)
- ton-labs-types: Fixed cells counter for telemetry
- ton-labs-vm: Fix dup, over, pushint printing in a trace