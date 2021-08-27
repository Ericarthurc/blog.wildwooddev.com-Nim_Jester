# Changelog

All notable changes to this project will be documented in this file.

Addition of markdown posts will not be versioned or require a changelog update.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.3] - 2021-08-26

### Changed

- Put conditional switch on loading of `highlight.min.js` per karax proc | this should help save load times on index pages
- Cleaned up prologue traces from `templates/error` in preparation for use with Jester

## [0.9.2] - 2021-08-25

### Added

- TODO.md

### Changed

- Updated `utils/parsers/getMetaSeq()` line 62 | `file.path.split(".m")` to stop any filenames with a `.` from being split incorrectly

### Fixed

- Updated `sort()` in `utils/parsers/getMetaSeq()` to fix `if xa[0].split(" ")[1] < ya[0].split(" ")[1]: 1`

## [0.9.1] - 2021-08-25

### Changed

- Updated `sort()` in `utils/parsers/getMetaSeq()` with custom string comparision | benchmarks show over 4 times performance gain

## [0.1.0] - 2021-08-24

- Init commit
