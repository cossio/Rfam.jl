#=
# Rfam.jl usage example
=#

import Rfam

# Define a directory to save data and the RFAM version.

const RFAM_DIR = tempdir()
const RFAM_VERSION = "14.7"
nothing #hide

# Use `Rfam.fasta_file` to fetch the fasta file of a family.

fasta = Rfam.fasta_file("RF00162"; dir=RFAM_DIR, version=RFAM_VERSION)
nothing #hide
