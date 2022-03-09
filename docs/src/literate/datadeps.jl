#=
# Datadeps

Rfam.jl can fetch key files from the server, which can be used with Infernal.jl.
=#

import Rfam

# Path to `Rfam.cm` file containing covariance models of all the families.

Rfam.cm()
