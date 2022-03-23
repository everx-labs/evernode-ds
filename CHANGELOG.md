# Release Notes

All notable changes to this project will be documented in this file.

## [0.1.5] – 2022-03-23

### Improvements

- ton-labs-node dependency is fixed to `3020fa75d73de06433fb162e64dcc830acdf9d6e`
- updated Q-Server to [`0.48.1`](https://github.com/tonlabs/ton-q-server/blob/master/CHANGELOG.md#0481---2022-03-16)

**Attention! Devnet is going through an update that will lead to a breaking change in account format which may cause your nodes to stop working.
To fix it update your DApp Server to 0.1.5 version.**


## [0.1.4] – 2022-01-14

### Improvements

- ton-labs-node dependency is fixed to `3037a6cf279aac5826035c66d8b822fbdecf3e1a`
- updated ArangoDB to 3.7.15
- tuned ArangoDB memory limits

## [0.1.3] – 2021-11-19

### Improvements

- ton-labs-node dependency is fixed to `8b0fd1cd8dbcbbd55b278ed04842aa551f61e690`
- ton-labs-node: implemented a mechanism with fixed dependencies
- changed service to detect external IP
- ton-labs-node: disabled RUST_BACKTRACE to improve performance

## [0.1.2] – 2021-10-21

### Improvements

- ton-labs-node dependency is fixed to `9fd95b11b36e0af673002911fd843009cf1a3629`
  
### Fixed

- ton-labs-node: OOM condition fix
- ton-labs-node: fix for node sync failure after reboot

## [0.1.1] – 2021-10-20

### Improvements

- ton-labs-node dependency is fixed to `8acc92c2b2efb47f7f703b1c4a6722bfca648751`
- ton-labs-node: updated RUST to 1.55


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
