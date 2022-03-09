module Rfam

using Downloads: download
import DataDeps
using DataDeps: DataDep, @datadep_str
using Scratch: @get_scratch!
using FASTX: FASTA
import Gzip_jll

include("datadeps.jl")
include("fetch.jl")
include("util.jl")

const version = "14.7"
const baseurl = "http://ftp.ebi.ac.uk/pub/databases/Rfam/" * version

cache = "" # store downloaded files (set by @get_scratch! in __init__)

function __init__()
    register_datadeps()

    # directory to store downloaded families
    global cache = @get_scratch!("rfam")
end

end
