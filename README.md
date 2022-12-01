# Rfam Julia package

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/cossio/Rfam.jl/blob/master/LICENSE.md)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://cossio.github.io/Rfam.jl/stable)
[![](https://img.shields.io/badge/docs-dev-blue.svg)](https://cossio.github.io/Rfam.jl/dev)

![](https://github.com/cossio/Rfam.jl/workflows/CI/badge.svg)
[![codecov](https://codecov.io/gh/cossio/Rfam.jl/branch/master/graph/badge.svg?token=i8LbFG9gdj)](https://codecov.io/gh/cossio/Rfam.jl)
![GitHub repo size](https://img.shields.io/github/repo-size/cossio/Rfam.jl)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/cossio/Rfam.jl)

Julia package to interface with the [Rfam](https://rfam.org) database. Only takes care of finding, downloading, and returning the path to files from the database (e.g. `Rfam.cm`, fasta files, etc.).

## Installation

This package is registered. Install with:

```julia
import Pkg
Pkg.add("Rfam")
```

This package does not export any symbols.

## Example

```julia
import Rfam
import FASTX

fasta = Rfam.fasta_file("RF00162"); # downloads `RF00162.fasta` file and returns local path
records = collect(FASTX.FASTA.Reader(open(fasta))); # convert to Fasta records
```

## Related

* https://github.com/cossio/Infernal.jl