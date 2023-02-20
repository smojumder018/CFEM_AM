function Mechanical_boundary(mesh, mesh_cord)
    nnode=length(mesh)
    coords=mesh_cord
    nlim = zeros(nnode)
    for i = 1:nnode
        if coords[i, 2] == minimum(coords[:, 2])
            nlim[i] = i
        end
    end
    index = any(nlim .!= 0, dims=2)
    return index
end

function Mechanical_boundary_load(mesh, mesh_cord)
    nnode=length(mesh)
    coords=mesh_cord
    nlim = zeros(nnode)
    for i = 1:nnode
        if coords[i, 2] == maximum(coords[:, 2])
            nlim[i] = i
        end
    end
    index = any(nlim .!= 0, dims=2)
    return index
end

index= Mechanical_boundary(mesh, mesh_cord)+ Mechanical_boundary_load(mesh, mesh_cord)