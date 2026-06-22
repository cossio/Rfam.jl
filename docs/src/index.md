# Rfam.jl

Julia package to interface with the [Rfam](https://rfam.org) database.
It downloads and caches Rfam data files locally, then returns their paths so
they can be consumed by other Julia packages and external tools.

This package does not export any symbols; all functions are accessed through the
`Rfam.` prefix.

## Installation

This package is registered. Install it with:

```julia
import Pkg
Pkg.add("Rfam")
```

## Configuration

Before using the download helpers, configure a local cache directory and the
Rfam release to use:

```julia
import Rfam
Rfam.set_rfam_directory("/path/to/rfam-data")
Rfam.set_rfam_version("14.7")
```

These settings are stored in a `LocalPreferences.toml` file (via
[Preferences.jl](https://github.com/JuliaPackaging/Preferences.jl)) and persist
across Julia sessions. Alternatively, the package can be configured with the
environment variables `JULIA_RFAM_DIR` and `JULIA_RFAM_VERSION`. Preference
values take precedence over environment variables.

## Contents

```@contents
Pages = ["literate/tutorial.md", "reference.md"]
Depth = 2
```

## Related packages

- [Infernal.jl](https://github.com/cossio/Infernal.jl)
