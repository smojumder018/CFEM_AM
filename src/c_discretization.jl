# comment
r=4
nnode=length(mesh)
nelem=size(mesh_connect,1)
coords=mesh_cord

function patch_mesh(mesh_connect, nnode, r)
    # patch
    patchmesh = []
    connect=mesh_connect
    for i = 1:size(connect, 1)
        patch_nodes = [connect[i, 1]]
        for nr = 1:r
            push!(patch_nodes, connect[i, 2] - r + nr - 1)
        end
        append!(patch_nodes, connect[i, 2:end])
        for nr = 1:r
            push!(patch_nodes, connect[i, end] + nr)
        end      
        patchmesh = vcat(patchmesh, patch_nodes)
    end

    patchmesh[patchmesh .<= 0] .= 1
    patchmesh[patchmesh .>= nnode + 1] .= nnode
    patchmesh=reshape(patchmesh,2*r+3,size(connect, 1))

    return patchmesh'
end

patchmesh=patch_mesh(mesh_connect, nnode, r)

#Gauss_point
ng=16
ra=4
re=r
dPhi_c=[]
Phi_c=[]
