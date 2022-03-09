"""
    fetch(family)

Returns a family as a vector of `FASTA.Record`.
"""
function fetch(family::String)
    path = joinpath(cache, "$family.fa")
    if !isfile(path)
        url = "$baseurl/fasta_files/$family.fa.gz"
        download(url, path * ".gz"; timeout = Inf)
        gunzip(path) # decompress
    end

    records = FASTA.Record[]
    open(FASTA.Reader, path) do reader
        for record in reader
            push!(records, record)
        end
    end
    return records
end
