function Ferrite.create_vtk_griddata(grid::NonConformingGrid{dim,C,T,CIT}) where {dim,C,T,CIT}
    cls = WriteVTK.MeshCell[]
    for cell in getcells(grid)
        celltype = Ferrite.cell_to_vtkcell(typeof(cell))
        push!(cls, WriteVTK.MeshCell(celltype, Ferrite.nodes_to_vtkorder(cell)))
    end
    coords = reshape(reinterpret(T, getnodes(grid)), (dim, getnnodes(grid)))
    return coords, cls
end

function Ferrite.create_vtk_grid(filename::AbstractString, grid::NonConformingGrid{dim,C,T,CIT}; kwargs...) where {dim,C,T,CIT}
    coords, cls = Ferrite.create_vtk_griddata(grid)
    return WriteVTK.vtk_grid(filename, coords, cls; kwargs...)
end
