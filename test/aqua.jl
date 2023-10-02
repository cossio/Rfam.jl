import Aqua
import Rfam
using Test: @testset

@testset verbose = true "aqua" begin
    Aqua.test_all(Rfam)
end
