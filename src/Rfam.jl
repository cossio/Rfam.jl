module Rfam

using Downloads: download
using Scratch: @get_scratch!, clear_scratchspaces!
using FASTX: FASTA
import Gzip_jll

include("files.jl")
include("fetch.jl")
include("util.jl")

const rfam_version = "14.7"
const rfam_baseurl = "http://ftp.ebi.ac.uk/pub/databases/Rfam/$rfam_version"
cache = "" # directory to store downloaded files (set during __init__)

function __init__()
    # Directory to store downloaded files.
    # This space will be unique for each Rfam database version.
    global cache = @get_scratch!("Rfam-$rfam_version")
end

"""
    clear()

Removes all downloaded data.
"""
function clear()
    clear_scratchspaces!(Rfam)
end

end
