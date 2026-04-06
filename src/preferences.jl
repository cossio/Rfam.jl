"""
    set_rfam_directory(dir)

Sets the directory where Rfam data is downloaded in a LocalPreferences.toml file.
"""
function set_rfam_directory(dir)
    if isdir(dir)
        @set_preferences!("RFAM_DIR" => dir)
        @info "RFAM Directory $dir set."
    else
        throw(ArgumentError("Invalid directory path: $dir"))
    end
end

"""
    get_rfam_directory()

Returns the directory used to cache Rfam data.

The value is read from `LocalPreferences.toml` when available and falls back to
the `JULIA_RFAM_DIR` environment variable.
"""
function get_rfam_directory()
    if @has_preference("RFAM_DIR")
        return @load_preference("RFAM_DIR")
    elseif haskey(ENV, "JULIA_RFAM_DIR")
        return ENV["JULIA_RFAM_DIR"]
    else
        error("RFAM_DIR not set; use `Rfam.set_rfam_directory` to set it")
    end
end

"""
    set_rfam_version(version)

Sets the version of Rfam used in a LocalPreferences.toml file.
"""
function set_rfam_version(version)
    @set_preferences!("RFAM_VERSION" => version)
    @info "Rfam version $version set."
end

"""
    get_rfam_version()

Returns the configured Rfam release version.

The value is read from `LocalPreferences.toml` when available and falls back to
the `JULIA_RFAM_VERSION` environment variable.
"""
function get_rfam_version()
    if @has_preference("RFAM_VERSION")
        return @load_preference("RFAM_VERSION")
    elseif haskey(ENV, "JULIA_RFAM_VERSION")
        return ENV["JULIA_RFAM_VERSION"]
    else
        error("RFAM_VERSION not set; use `Rfam.set_rfam_version` to set it")
    end
end
