# Changelog

All notable changes to this project will be documented in this file. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased

## 3.0.0

### Breaking changes

- New preferences functions, no need to restart Julia after changing a preference. Removed constants `RFAM_DIR`, `RFAM_VERSION`.

## v2.0.4

- Add `seed_tree`.

## v2.0.3

- Fix `Rfam.seed` typo in filename.

## v2.0.2

- Use https instead of http.

## v2.0.1

- Fix bug in Rfam.cm [d02d6804b85186018f178af4430eb64e35081366].

## v2.0.0

- Allow `dir`, `version` options, bypassing LocalPreferences.toml.
- Changed some names, `base_url, version_dir, fasta_dir`.

## v1.0.0

- Release v1.0.0.
- This CHANGELOG file.
- Functions in the package always return paths to files only. You must parse and load this files.