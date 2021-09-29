# Release Notes

All notable changes to this project will be documented in this file.

## [0.1.0] – 2021-09-27

### Improvements

- Fixed ton-labs-node dependency to `6e6856ace25e425e07d1d2297686a9ea51524d0d`
- Not-indexed arangodb was removed, now all queries, fast and slow are executed on the same arangodb.
- Increased memlimit for Rust Node
- Changed default Rust Node log config
  
### Fixed

- Memory leaks were fixed in Rust Node
