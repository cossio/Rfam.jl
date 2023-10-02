# Rfam Julia package

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