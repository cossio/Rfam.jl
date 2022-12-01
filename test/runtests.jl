using Test: @test, @testset
import Rfam

@test Rfam.RFAM_DIR == "/DATA/cossio/temp/RFAM"
@test Rfam.RFAM_VERSION == "14.7"

@testset "fasta_file" begin
    fasta = Rfam.fasta_file("RF00162")
    @test isfile(fasta)
end
