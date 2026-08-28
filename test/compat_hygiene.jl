import Rfam
import TestCompatHygiene
using Test: @testset

@testset verbose = true "compat hygiene" begin
    TestCompatHygiene.test_all(Rfam)
end
