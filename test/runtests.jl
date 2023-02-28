using CFEM_AM
using Test

# Import the material and Elas3D functions from the module being tested
include("../src/material.jl")

# Define a test module

    # Import the material and Elas3D functions into the test module
    import ..material
    import ..Elas3D


    function test_Elas3D()
    # Define the expected values for G, K, and C
    mat = material(1, 0.3)
    expected_G = 0.3846153846153846
    expected_K = 0.8333333333333333
    expected_C = [1.34615384615385	0.576923076923077	0.576923076923077	0	0	0;
    0.576923076923077	1.34615384615385	0.576923076923077	0	0	0;
    0.576923076923077	0.576923076923077	1.34615384615385	0	0	0;
    0	0	0	0.384615384615385	0	0;
    0	0	0	0	0.384615384615385	0;
    0	0	0	0	0	0.384615384615385]

    # Calculate the actual values for G, K, and C using the Elas3D function
    actual_G, actual_K, actual_C = Elas3D(mat)

    # Test that the actual values match the expected values
    @test isapprox(actual_G, expected_G, rtol=1e-6)
    @test isapprox(actual_K, expected_K, rtol=1e-6)
    @test isapprox(actual_C, expected_C, rtol=1e-6)
end

# Define a test set
@testset "Elas3D tests" begin
    # Run the test function
    test_Elas3D()
end





@testset "CFEM_AM.jl" begin
    # Write your tests here.
end
