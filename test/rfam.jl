using Test: @test, @testset
import Rfam

const RFAM_DIR = mktempdir()
const RFAM_VERSION = "14.7"

@info "Using temp dir:" RFAM_DIR

fasta = Rfam.fasta_file("RF00162"; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(fasta)

cmfile = Rfam.cm(; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(cmfile)

seed_file = Rfam.seed(; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(seed_file)

seed_tree = Rfam.seed_tree("RF00162"; dir=RFAM_DIR, version=RFAM_VERSION)
@test isfile(seed_tree)
