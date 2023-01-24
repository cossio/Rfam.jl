module Rfam

using Downloads: download
using Preferences: @set_preferences!, @load_preference
import Gzip_jll
import Tar
#using CodecZlib: GzipDecompressorStream

# make the loading RFAM files thread-safe
const RFAM_LOCK = ReentrantLock()

# Stores downloaded Rfam files
const RFAM_DIR = @load_preference("RFAM_DIR")
const RFAM_VERSION = @load_preference("RFAM_VERSION")

isnothing(RFAM_DIR) && @debug "RFAM_DIR not set; use `Rfam.set_rfam_directory` and restart Julia"
isnothing(RFAM_VERSION) && @debug "RFAM_VERSION not set; use `Rfam.set_rfam_version` and restart Julia"

function set_rfam_directory(dir)
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

base_url(; version=RFAM_VERSION) = "https://ftp.ebi.ac.uk/pub/databases/Rfam/$version"
version_dir(; dir=RFAM_DIR, version=RFAM_VERSION) = mkpath(joinpath(dir, version))
fasta_dir(; dir=RFAM_DIR, version=RFAM_VERSION) = mkpath(joinpath(version_dir(; dir, version), "fasta_files"))

"""
    fasta_file(family_id)

Returns local path to `.fasta` file of `family_id`.
"""
function fasta_file(family_id::AbstractString; dir=RFAM_DIR, version=RFAM_VERSION)
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
function cm(; dir=RFAM_DIR, version=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(; dir, version), "Rfam.cm")
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
        local_path = joinpath(version_dir(; dir, version), "Rfam.seed")
        if !isfile(local_path)
            @info "Downloading Rfam.seed to $local_path ..."
            rfam_base_url = base_url(; version)
            download("$rfam_base_url/Rfam.seed.gz", "$local_path.gz"; timeout = Inf)
            gunzip("$local_path.gz")
        end
        return local_path
    end
end

"""
    seed_tree(family_id)

Returns the path to the `.seed_tree` of the family.
"""
function seed_tree(family_id::AbstractString; dir=RFAM_DIR, version=RFAM_VERSION)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(; dir, version), "Rfam.seed_tree")
        if !isdir(local_path)
            @info "Downloading Rfam.seed_tree.tar.gz to $local_path ..."
            rfam_base_url = base_url(; version)
            download("$rfam_base_url/Rfam.seed_tree.tar.gz", "$local_path.tar.gz"; timeout = Inf)

            # Rfam.seed_tree.tar.gz seems not to be really gunzipped, it's just a Tar archive.
            # The Tar is extracts a nested dir, so we extract at a temp location and then move
            temp = mktempdir()
            Tar.extract("$local_path.tar.gz", temp)
            mv(joinpath(temp, "Rfam.seed_tree"), local_path)
        end
        return joinpath(local_path, "$family_id.seed_tree")
    end
end

# decompress a gunzipped file.
gunzip(file::AbstractString) = run(`$(Gzip_jll.gzip()) -d $file`)

# extract a tarball (.tar.gz) to a directory
# function tarball(file::AbstractString)
#     if endswith(file, ".tar.gz")
#         outdir = file[1:end - 7]
#     elseif endswith(file, ".tgz")
#         outdir = file[1:end - 4]
#     else
#         throw(ArgumentError("file name does not end with .tar.gz or .tgz"))
#     end
#     open(GzipDecompressorStream, file) do io
#         Tar.extract(io, outdir)
#     end
# end

end # module
