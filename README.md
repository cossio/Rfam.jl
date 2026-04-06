# Rfam Julia package

Julia package to interface with the [Rfam](https://rfam.org) database.
It downloads and caches Rfam data files locally, then returns their paths so
they can be consumed by other Julia packages and external tools.

## Installation

This package is registered. Install with:

```julia
import Pkg
Pkg.add("Rfam")
```

This package does not export any symbols.

## Configuration

Before using the download helpers, configure a local cache directory and the
Rfam release to use:

```julia
import Rfam

Rfam.set_rfam_directory("/path/to/rfam-data")
Rfam.set_rfam_version("14.7")
```

You can also configure the package with environment variables:

- `JULIA_RFAM_DIR`
- `JULIA_RFAM_VERSION`

Preference values stored by `set_rfam_directory` and `set_rfam_version` take
precedence over environment variables.

## Usage

```julia
import Rfam
import FASTX

Rfam.set_rfam_directory("/path/to/rfam-data")
Rfam.set_rfam_version("14.7")

fasta = Rfam.fasta_file("RF00162")
records = collect(FASTX.FASTA.Reader(open(fasta)))

cmfile = Rfam.cm()
seed = Rfam.seed()
```

Downloaded files are cached under the configured directory, and repeated calls
reuse the local copies.

## API overview

- `Rfam.fasta_file(family_id)`: path to a family FASTA file
- `Rfam.cm()`: path to `Rfam.cm`
- `Rfam.clanin()`: path to `Rfam.clanin`
- `Rfam.seed()`: path to `Rfam.seed`
- `Rfam.seed_tree(family_id)`: path to a family seed tree file
- `Rfam.set_rfam_directory(dir)`: store the local cache directory preference
- `Rfam.get_rfam_directory()`: get the configured cache directory
- `Rfam.set_rfam_version(version)`: store the Rfam release preference
- `Rfam.get_rfam_version()`: get the configured Rfam release

## Related

* https://github.com/cossio/Infernal.jl
