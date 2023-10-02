using Test: @test, @testset
import Rfam

Rfam.set_rfam_directory(mktempdir())
Rfam.set_rfam_version("14.7")

@info "Using temp directory:" Rfam.get_rfam_directory()

fasta = Rfam.fasta_file("RF00162")
@test isfile(fasta)

cmfile = Rfam.cm()
@test isfile(cmfile)

seed_file = Rfam.seed()
@test isfile(seed_file)

seed_tree = Rfam.seed_tree("RF00162")
@test isfile(seed_tree)
