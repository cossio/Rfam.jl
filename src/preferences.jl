# Stores downloaded Rfam files
function set_rfam_directory(dir)
    if isdir(dir)
        @set_preferences!("RFAM_DIR" => dir)
        @info "RFAM Directory $dir set."
    else
        throw(ArgumentError("Invalid directory path: $dir"))
    end
end

function get_rfam_directory()
    rfam_dir = @load_preference("RFAM_DIR")
    if isnothing(rfam_dir)
        error("RFAM_DIR not set; use `Rfam.set_rfam_directory` to set it")
    else
        return rfam_dir
    end
end

# Determines the version of Rfam used
function set_rfam_version(version)
    @set_preferences!("RFAM_VERSION" => version)
    @info "Rfam version $version set."
end

function get_rfam_version()
    rfam_version = @load_preference("RFAM_VERSION")
    if isnothing(rfam_version)
        error("RFAM_VERSION not set; use `Rfam.set_rfam_version` to set it")
    else
        return rfam_version
    end
end
