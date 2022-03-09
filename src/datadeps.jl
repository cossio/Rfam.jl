function register_datadeps()
    # Rfam.cm
    url = baseurl * "/Rfam.cm.gz"
    datadep = DataDep("Rfam.cm", "", url, post_fetch_method = gunzip)
    DataDeps.register(datadep)

    # Rfam.clanin
    url = baseurl * "/Rfam.clanin"
    datadep = DataDep("Rfam.clanin", "", url)
    DataDeps.register(datadep)

    # Rfam seeds
    url = baseurl * "/Rfam.seed.gz"
    datadep = DataDep("Rfam.seed", "", url, post_fetch_method = gunzip)
    DataDeps.register(datadep)

    # Rfam phylogenetic tree
    url = baseurl * "/Rfam.seed_tree.tar.gz"
    datadep = DataDep("Rfam.seed_tree", "", url, post_fetch_method = gunzip)
    DataDeps.register(datadep)
end

"""
    cm()

Returns the path to `Rfam.cm` file containing the covariance models of all the families.
"""
cm() =  joinpath(datadep"Rfam.cm", "Rfam.cm")

"""
    clanin()

Returns the path to `Rfam.clanin`.
"""
clanin() = joinpath(datadep"Rfam.clanin", "Rfam.clanin")

"""
    seed()

Returns the path to `Rfam.seed`.
"""
seed() = joinpath(datadep"Rfam.seed", "Rfam.seed")

"""
    seed_tree()

Returns the path to `Rfam.seed_tree`.
"""
seed_tree() = joinpath(datadep"Rfam.seed_tree", "Rfam.seed_tree")
