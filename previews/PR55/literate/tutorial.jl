# # Tutorial
#
# This tutorial shows how to configure `Rfam.jl` and download data files from
# the [Rfam](https://rfam.org) database.

# ## Setup
#
# First we import the package.

import Rfam

# `Rfam.jl` caches all downloaded files inside a directory of our choosing, and
# fetches files for a particular Rfam release. For this tutorial we use a
# temporary directory and release `14.7`. In a real project you would point the
# directory to a persistent location instead.

Rfam.set_rfam_directory(mktempdir())
Rfam.set_rfam_version("14.7")

# We can query the current configuration at any time:

Rfam.get_rfam_directory()

#-

Rfam.get_rfam_version()

# ## Downloading a family FASTA file
#
# The function [`Rfam.fasta_file`](@ref) returns the local path to the FASTA
# file of a given family, downloading and decompressing it on first use. Here we
# fetch the SAM riboswitch family `RF00162`.

fasta = Rfam.fasta_file("RF00162")

# The returned value is a path to a file on disk:

isfile(fasta)

# We can read it with [FASTX.jl](https://github.com/BioJulia/FASTX.jl), using an
# `open(...) do` block so the file handle is closed deterministically:

import FASTX
records = open(FASTX.FASTA.Reader, fasta) do reader
    collect(reader)
end
length(records)

# Let us look at the first record:

first(records)

# Subsequent calls reuse the cached file instead of downloading it again, so
# they return immediately.

# ## Other data files
#
# The package provides similar helpers for the other files distributed by Rfam.
# These download larger archives, so they are only listed here rather than
# executed:
#
# ```julia
# Rfam.cm()                  # path to `Rfam.cm` (covariance models)
# Rfam.seed()                # path to `Rfam.seed` (seed alignments)
# Rfam.clanin()              # path to `Rfam.clanin`
# Rfam.seed_tree("RF00162")  # path to a family seed tree
# ```
#
# See the [Reference](@ref) for the full list of available functions.
