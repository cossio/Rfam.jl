#=
# Rfam.jl usage example
=#

import Rfam

# Use `Rfam.fetch` to get the set of sequences in a family, as a
# Vector{FASTA.Record}:

fasta = Rfam.fetch("RF00162")
