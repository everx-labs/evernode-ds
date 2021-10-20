# Release Notes

All notable changes to this project will be documented in this file.

## [0.1.1] – 2021-10-20

### Improvements

- ton-labs-node dependency is fixed to `8acc92c2b2efb47f7f703b1c4a6722bfca648751`
- ton-labs-node: updated RUST to 1.55
  
### Fixed

- ton-labs-node: OOM condition fix
- ton-labs-node: fix for node sync failure after reboot

## [0.1.0] – 2021-09-27

### Improvements

- ton-labs-node dependency is fixed to `f4a59efa0478e29305b207cfa2689df4a809ccf5`
- Not-indexed arangodb was removed, now all queries, fast and slow are executed on the same arangodb.
- Increased memlimit for Rust Node
- Changed default Rust Node log config
- Updated cp-kafka-connect to 5.3.6
- Disabled Rust Node garbage collector
  
### Fixed

- ton-labs-node: Fixed possible error while block broadcast's checking  (after node's restart)
- ton-labs-types: Fixed cells counter for telemetry
- ton-labs-vm: Fix dup, over, pushint printing in a trace