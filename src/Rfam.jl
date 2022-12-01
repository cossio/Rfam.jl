module Rfam

using Downloads: download
using Preferences: @set_preferences!, @load_preference
import Gzip_jll

# make the loading RFAM files thread-safe
const RFAM_LOCK = ReentrantLock()

# Stores downloaded Rfam files
const RFAM_DIR = @load_preference("RFAM_DIR")
const RFAM_VERSION = @load_preference("RFAM_VERSION")

isnothing(RFAM_DIR) && @debug "RFAM_DIR not set; use `Rfam.set_rfam_directory` and restart Julia"
isnothing(RFAM_VERSION) && @debug "RFAM_VERSION not set; use `Rfam.set_rfam_version` and restart Julia"

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

base_url(; version=RFAM_VERSION) = "http://ftp.ebi.ac.uk/pub/databases/Rfam/$version"
version_dir(; dir=RFAM_DIR, version=RFAM_VERSION) = mkpath(joinpath(dir, version))
fasta_dir(; dir=RFAM_DIR, version=RFAM_VERSION) = mkpath(joinpath(version_dir(; dir, version), "fasta_files"))

"""
    fasta_file(family_id)

Returns local path to `.fasta` file of `family_id`.
"""
function fasta_file(family_id::String; dir::AbstractString=RFAM_DIR, version::AbstractString=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(fasta_dir(; dir, version), "$family_id.fa")
        if !isfile(local_path)
            @info "Downloading $family_id to $local_path ..."
            rfam_base_url = base_url(; version)
            url = "$rfam_base_url/fasta_files/$family_id.fa.gz"
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
function cm(; dir=RFAM_DIR, version::AbstractString=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(; dir, version), "$family_id.fa")
        if !isfile(local_path)
            @info "Downloading Rfam.cm to $local_path ..."
            rfam_base_url = base_url(; version)
            download("$rfam_base_url/Rfam.cm.gz", "$local_path.gz"; timeout = Inf)
            gunzip(local_path * ".gz")
        end
        return local_path
    end
end

"""
    clanin()

Returns the path to `Rfam.clanin`.
"""
function clanin(; dir=RFAM_DIR, version=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(; dir, version), "Rfam.clanin")
        if !isfile(local_path)
            @info "Downloading Rfam.clanin to $local_path ..."
            rfam_base_url = base_url(; version)
            download("$rfam_base_url/Rfam.clanin", "$local_path"; timeout = Inf)
        end
        return local_path
    end
end

"""
    seed()

Returns the path to `Rfam.seed`.
"""
function seed(; dir=RFAM_DIR, version=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(; dir, version), "Rfam.clanin")
        if !isfile(local_path)
            @info "Downloading Rfam.seed to $local_path ..."
            rfam_base_url = base_url(; version)
            download("$rfam_base_url/Rfam.seed.gz", "$local_path.gz"; timeout = Inf)
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
