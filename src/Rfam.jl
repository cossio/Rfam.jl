module Rfam

using Downloads: download
using Preferences: @set_preferences!, @load_preference
import Gzip_jll
import Tar
#using CodecZlib: GzipDecompressorStream

include("preferences.jl")

# make the loading of RFAM files thread-safe
const RFAM_LOCK = ReentrantLock()

base_url() = "https://ftp.ebi.ac.uk/pub/databases/Rfam/$(get_rfam_version())"
version_dir() = mkpath(joinpath(get_rfam_directory(), get_rfam_version()))
fasta_dir() = mkpath(joinpath(version_dir(), "fasta_files"))

"""
    fasta_file(family_id)

Returns local path to `.fasta` file of `family_id`.
"""
function fasta_file(family_id::AbstractString)
    lock(RFAM_LOCK) do
        local_path = joinpath(fasta_dir(), "$family_id.fa")
        if !isfile(local_path)
            @info "Downloading $family_id to $local_path ..."
            rfam_base_url = base_url()
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
function cm()
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(), "Rfam.cm")
        if !isfile(local_path)
            @info "Downloading Rfam.cm to $local_path ..."
            rfam_base_url = base_url()
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
function clanin()
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(), "Rfam.clanin")
        if !isfile(local_path)
            @info "Downloading Rfam.clanin to $local_path ..."
            rfam_base_url = base_url()
            download("$rfam_base_url/Rfam.clanin", "$local_path"; timeout = Inf)
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
        local_path = joinpath(version_dir(), "Rfam.seed")
        if !isfile(local_path)
            @info "Downloading Rfam.seed to $local_path ..."
            rfam_base_url = base_url()
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
function seed_tree(family_id::AbstractString)
    lock(RFAM_LOCK) do
        local_path = joinpath(version_dir(), "Rfam.seed_tree")
        if !isdir(local_path)
            @info "Downloading Rfam.seed_tree.tar.gz to $local_path ..."
            rfam_base_url = base_url()
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
