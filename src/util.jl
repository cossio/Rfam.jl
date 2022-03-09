"""
    filename(path)

Get the file name from a path, dropping directory path and extension.
"""
filename(path::String) = first(splitext(basename(path)))

"""
    gunzip(file)

Decompress a gunzipped file.
"""
gunzip(file::String) = Gzip_jll.gzip() do gzip
    run(`$gzip -d $file`)
end
