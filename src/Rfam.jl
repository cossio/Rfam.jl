module Rfam

using Downloads: download
using Scratch: @get_scratch!, clear_scratchspaces!
using FASTX: FASTA
using Preferences: @set_preferences!, @load_preference
import Gzip_jll

# make the loading RFAM files thread-safe
const RFAM_LOCK = ReentrantLock()

# Stores downloaded Rfam files
const RFAM_DIR = @load_preference("RFAM_DIR")
const RFAM_VERSION = @load_preference("RFAM_VERSION")

isnothing(RFAM_DIR) && @warn "Set RFAM_DIR (use `Rfam.set_rfam_directory`) and restart Julia"
isnothing(RFAM_VERSION) && @warn "Set RFAM_VERSION (use `Rfam.set_rfam_version`) and restart Julia"

function set_rfam_directory(dir::AbstractString)
    if isdir(dir)
        @set_preferences!("RFAM_DIR" => dir)
        @info "RFAM Directory $dir set; restart Julia for this change to take effect."
    else
        throw(ArgumentError("Invalid directory path: $dir"))
    end
end

function set_rfam_version(version)
    @set_preferences!("RFAM_VERSION" => version)
    @info "Rfam version $version set; restart Julia for this change to take effect."
end

if !isnothing(RFAM_DIR) && !isnothing(RFAM_VERSION)
    const RFAM_BASE_URL = "http://ftp.ebi.ac.uk/pub/databases/Rfam/$RFAM_VERSION"
    const RFAM_BASE_DIR = mkpath(joinpath(RFAM_DIR, RFAM_VERSION))
    const RFAM_FASTA_DIR = mkpath(joinpath(RFAM_BASE_DIR, "fasta_files"))
end

"""
    clear_all_data()

Removes all downloaded data.
"""
function clear_all_data()
    rm(RFAM_BASEDIR; force=true, recursive=true)
    mkpath(RFAM_BASEDIR)
end

"""
    fasta_file(family_id)

Returns local path to `.fasta` file of `family_id`.
"""
function fasta_file(family_id::String)
    lock(RFAM_LOCK) do
        local_path = joinpath(RFAM_FASTA_DIR, "$family_id.fa")
        if !isfile(local_path)
            @info "Downloading $family_id to $local_path ..."
            url = "$RFAM_BASE_URL/fasta_files/$family_id.fa.gz"
            download(url, local_path * ".gz"; timeout = Inf)
            gunzip(local_path * ".gz")
        end
        return local_path
    end
end

"""
    cm()

Returns the path to `Rfam.cm` file containing the covariance models of all the families.
"""
function cm()
    lock(RFAM_LOCK) do
        local_path = joinpath(RFAM_BASEDIR, "Rfam.cm")
        if !isfile(local_path)
            @info "Downloading Rfam.cm to $local_path ..."
            download(RFAM_BASE_URL * "/Rfam.cm.gz", "$local_path.gz"; timeout = Inf)
            gunzip(local_path * ".gz")
        end
        return local_path
    end
end

"""
    clanin()

Returns the path to `Rfam.clanin`.
"""
function clanin()
    lock(RFAM_LOCK) do
        local_path = joinpath(RFAM_BASE_DIR, "Rfam.clanin")
        if !isfile(local_path)
            @info "Downloading Rfam.clanin to $local_path ..."
            download("$RFAM_BASE_URL/Rfam.clanin", "$local_path"; timeout = Inf)
        end
        return local_path
    end
end

"""
    seed()

Returns the path to `Rfam.seed`.
"""
function seed()
    lock(RFAM_LOCK) do
        local_path = joinpath(cache, "Rfam.seed")
        if !isfile(local_path)
            @info "Downloading Rfam.seed to $local_path ..."
            download("$rfam_baseurl/Rfam.seed.gz", "$local_path.gz"; timeout = Inf)
            gunzip("$local_path.gz")
        end
        return local_path
    end
end

# decompress a gunzipped file.
gunzip(file::String) = Gzip_jll.gzip() do gzip
    run(`$gzip -d $file`)
end

end # module
