"""
    cm()

Returns the path to `Rfam.cm` file containing the covariance models of all the families.
"""
function cm()
    local_path = joinpath(cache, "Rfam.cm")
    if !isfile(local_path)
        @info "Downloading Rfam.cm to $local_path ..."
        download(rfam_baseurl * "/Rfam.cm.gz", "$local_path.gz"; timeout = Inf)
        gunzip(local_path * ".gz")
    end
    return local_path
end

"""
    clanin()

Returns the path to `Rfam.clanin`.
"""
function clanin()
    local_path = joinpath(cache, "Rfam.clanin")
    if !isfile(local_path)
        @info "Downloading Rfam.clanin to $local_path ..."
        download("$rfam_baseurl/Rfam.clanin", "$local_path"; timeout = Inf)
    end
    return local_path
end

"""
    seed()

Returns the path to `Rfam.seed`.
"""
function seed()
    local_path = joinpath(cache, "Rfam.seed")
    if !isfile(local_path)
        @info "Downloading Rfam.seed to $local_path ..."
        download("$rfam_baseurl/Rfam.seed.gz", "$local_path.gz"; timeout = Inf)
        gunzip("$local_path.gz")
    end
    return local_path
end
