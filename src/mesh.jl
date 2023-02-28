
function generate_mesh(min::Float64, max::Float64, h::Float64)

X=min:h:max
X=0.1*X
nx=size(X,1)
mesh=X
#Generate mesh cordinate
mesh_cord = zeros(nx, 2)
for i in 1:nx
    mesh_cord[i, 1] = Int64(i)  # set index number as an integer
    mesh_cord[i, 2] = mesh[i]  # set value of mesh in that index
end
#Generate mesh connectivity
mesh_connect = hcat(collect(1:nx-1), collect(1:nx-1), collect(2:nx))
return mesh, mesh_cord, mesh_connect
end

@time mesh, mesh_cord, mesh_connect=generate_mesh(-6.0,6.0,1/4)
#test comment#
#test comment 2