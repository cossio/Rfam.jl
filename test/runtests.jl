import Rfam
Rfam.set_rfam_directory(mktempdir())
Rfam.set_rfam_version("14.7")

module aqua_tests include("aqua.jl") end
module compat_hygiene_tests include("compat_hygiene.jl") end
module rfam_tests include("rfam.jl") end
