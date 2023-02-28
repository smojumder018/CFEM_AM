#=
Radial kernel function
 calling function: kernel function, kernel function derivative,
=#
using ForwardDiff
a, Wi = Gauss_points(ng)
function kernel_function(a, xi, ra)
    # kernel function
    z = abs(a - xi) / ra
    
    # cubic spline
    if 0 <= z <= 0.5
        phi_i = 2/3 - 4z^2 + 4z^3
    elseif 0.5 < z <= 1
        phi_i = 4/3 - 4z + 4z^2 - 4/3*z^3
    else
        phi_i = 0
    end
    
    return phi_i
end

function kernel_function_derivative(a, xi, ra)
    return ForwardDiff.derivative(a -> kernel_function(a, xi, ra), a)
end

using LinearAlgebra
using Base.Threads

function radial_kernel_function(r,ng,ra)
Phi_l = zeros(ng, 2r+1)
dPhi_l = zeros(ng, 2r+1)
Phi_r = zeros(ng, 2r+1)
dPhi_r = zeros(ng, 2r+1)
Phi_l_1 = []
Phi_l_2 = []
Phi_l_3 = []
dPhi_l_1 = []
dPhi_l_2 = []
dPhi_l_3 = []
PP = zeros(ng, r)
dPP = zeros(ng, r)

 Threads.@threads for i in 1:ng
    # center node at -1
    p = []
    phi_a = []
    dphi_a = []
    xi = -1 - 2r
    for ni in 1:(2r + 1)
        phi_i = kernel_function(a[i], xi, ra) # cubic spline
        push!(phi_a, phi_i)
        dphi_i = kernel_function_derivative(a[i], xi, ra) # derivative of cubic spline
        push!(dphi_a, dphi_i)
        xi += 2
    end
    Phi_l[i, :] = phi_a
    dPhi_l[i, :] = dphi_a

    # center node at 1
    # quadratic basis + cubic spline
    p = []
    phi_a = []
    dphi_a = []
    xi = 1 - 2r
    for ni in 1:(2r + 1)
        phi_i = kernel_function(a[i], xi, ra) # cubic spline
        push!(phi_a, phi_i)
        dphi_i = kernel_function_derivative(a[i], xi, ra) # derivative of cubic spline
        push!(dphi_a, dphi_i)
        xi += 2
    end

    Phi_r[i, :] = phi_a
    dPhi_r[i, :] = dphi_a

    pp = [1, a[i], a[i]^2, a[i]^3]

    dpp = [0, 1, 2*a[i], 3*a[i]^2]

    PP[i, :] = pp
    dPP[i, :] = dpp

end

Phi_ll, dPhi_ll = compute_values(-1, r, kernel_function, kernel_function_derivative, ra, Phi_l, dPhi_l, Phi_r, dPhi_r, PP, dPP)
Phi_rr, dPhi_rr = compute_values(1, r, kernel_function, kernel_function_derivative, ra, Phi_l, dPhi_l, Phi_r, dPhi_r, PP, dPP)
return Phi_ll,Phi_rr, dPhi_ll, dPhi_rr
end

@time Phi_ll,Phi_rr, dPhi_ll, dPhi_rr=radial_kernel_function(4,16,4)

function compute_values(s::Int, r::Int, kernel_function, kernel_function_derivative, ra, Phi_l, dPhi_l, Phi_r, dPhi_r, PP, dPP)
    Phi_l0 = zeros(2*r+1,2*r+1)
    dPhi_l0 = zeros(2*r+1,2*r+1)
    P = zeros(2*r+1,r)
    a0 = s - (2*r)
    for nj = 1:(2*r+1)
        phi_a = zeros(2*r+1)
        dphi_a = zeros(2*r+1)
        xi = s - (2*r)
        for ni = 1:(2*r+1)
            phi_i = kernel_function(a0, xi, ra) # cubic spline
            phi_a[ni] = phi_i
            dphi_i = kernel_function_derivative(a0, xi, ra) # derivative of cubic spline
            dphi_a[ni] = dphi_i
            xi = xi + 2
        end
        Phi_l0[nj, :] = phi_a
        dPhi_l0[nj, :] = dphi_a

        P0 = [1 a0 a0^2 a0^3]
        P[nj,:]=P0
        a0 = a0 + 2
    end

    R = Phi_l0
    B = (P' * inv(R) * P) \ (P' / R)
    A = R \ (Matrix{Float64}(I, size(R, 1), size(R, 1)) - P * B)

    if s == -1
        Phi_ll = Phi_l * A + PP * B
        dPhi_ll = dPhi_l * A + dPP * B
        return Phi_ll, dPhi_ll
    elseif s == 1
        Phi_rr = Phi_r * A + PP * B
        dPhi_rr = dPhi_r * A + dPP * B
        return Phi_rr, dPhi_rr
    end
end


