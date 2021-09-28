# Release Notes

All notable changes to this project will be documented in this file.

## [0.1.0] – 2021-09-27

### Improvements

- Fixed ton-labs-node dependency to <...>
- Not-indexed arangodb was removed, now all queries, fast and slow are executed on the same arangodb.
  
### Fixed

- Memory leaks were fixed in Rust Node
