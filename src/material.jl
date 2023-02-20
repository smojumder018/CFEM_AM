
mutable struct material
    E::Float64
    nu::Float64
    end

function Elas3D(mat::material)
    E=mat.E
    nu=mat.nu
    G=E/(2*(1+nu))
    K=E/(3*(1-2*nu))
        D=[1-nu nu nu 0 0 0;
           nu 1-nu nu 0 0 0;
           nu nu 1-nu 0 0 0;
           0 0 0 0.5-nu 0 0;
           0 0 0 0 0.5-nu 0;
           0 0 0 0 0 0.5-nu]
    
        C=E/(1+nu)/(1-2*nu)*D
        return G,K,C
    
end

mat=material(1,0.3)
G,K,C=Elas3D(mat)