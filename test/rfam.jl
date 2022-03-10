using Test: @test, @testset
import Rfam

@testset "Rfam fetch" begin
    fasta = Rfam.fetch("RF00162")
    @test fasta isa AbstractVector
    println(first(fasta))
end
