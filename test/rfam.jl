import Rfam
using Test: @test, @testset

fasta = Rfam.fasta_file("RF00162")
@test isfile(fasta)

cmfile = Rfam.cm()
@test isfile(cmfile)

seed_file = Rfam.seed()
@test isfile(seed_file)

seed_tree = Rfam.seed_tree("RF00162")
@test isfile(seed_tree)
