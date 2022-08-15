# Release Notes

All notable changes to this project will be documented in this file.

## [0.2.0] – 2022-08-15

### Improvements

- Added REMP support. Set REMP_ENABLED=true in scripts/env.sh


## [0.1.9] – 2022-08-12

### Improvements

- updated ton-labs-node from `5438eaab4db17c0c78869debf3e936078d9d7150` to `c5ee530c54199e81e2ca241a17ec23be7290229a`

### Fixed
- fixed IP address detection issue

## [0.1.8] – 2022-06-27

### Improvements

- updated ton-q-server from `0.52.0` to `0.52.1`
- updated ton-labs-node from `5c3951a4de03833a49079d1c07ad5a05798df169` to `5438eaab4db17c0c78869debf3e936078d9d7150`

### Fixed
- fixed `master.shard_hashes.shard` in master blocks in one-shard scenario

## [0.1.7] – 2022-06-27

### New

- support `query { blockchain { .. } }` GraphQL API queries in Evernode DApp Server

### Improvements

- updated ton-q-server from `0.48.1` to `0.52.0`
- updated ton-labs-node from `49a724639a175752f44bcda65d907f2ca3ad97aa` to `5c3951a4de03833a49079d1c07ad5a05798df169`
- updated kafka-connect-arangodb to custom solution with additional `overwritemode` parameter
- changed arangodb-messages-sink configuration to update messages instead of replacing
- added 20 new indexes to arangodb

## [0.1.6] – 2022-03-29

### Improvements

- ton-labs-node dependency is fixed to `49a724639a175752f44bcda65d907f2ca3ad97aa`
- Disabled big_messages_storage

## [0.1.5] – 2022-03-23

### New
- Support of new Account format for new TVM instruction INITCODEHASH
- Account.init_code_hash field added to API


### Improvements
- ton-labs-node dependency is fixed to `3020fa75d73de06433fb162e64dcc830acdf9d6e`
- updated Q-Server to [`0.48.1`](https://github.com/tonlabs/ton-q-server/blob/master/CHANGELOG.md#0481---2022-03-16)

**Attention! Devnet and Mainnet are going through an update that will lead to a breaking change in account format which may cause your nodes to stop working.
To fix it update your DApp Server to >=0.1.5 version.**


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
