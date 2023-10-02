#=
# Rfam.jl usage example
=#

import Rfam

# Define a directory to save data and the RFAM version.

Rfam.set_rfam_directory(tempdir())
Rfam.set_rfam_version("14.7")
nothing #hide

# Use `Rfam.fasta_file` to fetch the fasta file of a family.

fasta = Rfam.fasta_file("RF00162")
nothing #hide
