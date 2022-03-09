using Test: @test, @testset
using DataDeps: @datadep_str
import Rfam

@testset "Rfam fetch" begin
    fasta = Rfam.fetch("RF00162")
    @test fasta isa AbstractVector
    println(first(fasta))
end
