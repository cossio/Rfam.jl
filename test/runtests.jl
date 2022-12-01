using Test: @test, @testset
import Rfam

const RFAM_DIR = tempdir()
const RFAM_VERSION = "14.7"

@testset "fasta_file" begin
    fasta = Rfam.fasta_file("RF00162"; dir=RFAM_DIR, version=RFAM_VERSION)
    @test isfile(fasta)
end
