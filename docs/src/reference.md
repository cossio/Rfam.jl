# Reference

```@meta
CurrentModule = Rfam
```

This page documents all functions provided by `Rfam.jl`. None of them are
exported, so they must be called with the `Rfam.` prefix.

## Configuration

```@docs
Rfam.set_rfam_directory
Rfam.get_rfam_directory
Rfam.set_rfam_version
Rfam.get_rfam_version
```

## Data files

```@docs
Rfam.fasta_file
Rfam.cm
Rfam.seed
Rfam.clanin
Rfam.seed_tree
```

## Paths and URLs

```@docs
Rfam.base_url
Rfam.version_dir
Rfam.fasta_dir
```

## Internal helpers

```@docs
Rfam.gunzip
```
