using Ferrite
using Test
using FerriteAMR
using FerriteMeshParser
using WriteVTK
using LinearAlgebra, SparseArrays, ForwardDiff

get_geometry(::Ferrite.Interpolation{RefLine}) = Line
get_geometry(::Ferrite.Interpolation{RefQuadrilateral}) = Quadrilateral
get_geometry(::Ferrite.Interpolation{RefTriangle}) = Triangle
get_geometry(::Ferrite.Interpolation{RefPrism}) = Wedge
get_geometry(::Ferrite.Interpolation{RefHexahedron}) = Hexahedron
get_geometry(::Ferrite.Interpolation{RefTetrahedron}) = Tetrahedron

get_quadrature_order(::Lagrange{shape, order}) where {shape, order} = 2*order
get_quadrature_order(::Serendipity{shape, order}) where {shape, order} = 2*order
get_quadrature_order(::CrouzeixRaviart{shape, order}) where {shape, order} = 2*order+1

get_N(::Ferrite.Interpolation{shape, 1}) where {shape} = 19
get_N(::Ferrite.Interpolation{shape, 2}) where {shape} = 12
get_N(::Ferrite.Interpolation{shape, 3}) where {shape} = 8
get_N(::Ferrite.Interpolation{shape, 4}) where {shape} = 5
get_N(::Ferrite.Interpolation{shape, 5}) where {shape} = 3


function setup_poisson_problem(grid, interpolation, interpolation_geo, qr)
    # Construct Ferrite stuff
    dh = DofHandler(grid)
    add!(dh, :u, interpolation)
    _, vertexdicts, _, _ = Ferrite.__close!(dh);

    cellvalues = CellValues(qr, interpolation, interpolation_geo);

    return dh, vertexdicts, cellvalues
end

# Check L2 convergence
function check_and_compute_convergence(dh, cellvalues, forest; lmin, region_func)
    
    marked_cells = Vector{Int64}()
    levec = zeros(getnquadpoints(cellvalues))
    ifVec = [false,false,false,false]

    for (cellid,cell) in enumerate(CellIterator(dh))
    
        reinit!(cellvalues, cell)

        n_basefuncs = getnbasefunctions(cellvalues)
        coords = getcoordinates(cell)

        for (i, x) in enumerate(coords)
            ifVec[i] = region_func(x)
        end
        if_close = true in ifVec

        for q_point in 1:getnquadpoints(cellvalues)
            dΩ = getdetJdV(cellvalues, q_point)
            le = sqrt(dΩ)*2 
            x = spatial_coordinate(cellvalues, q_point, coords)
            ifVec[q_point] = le > lmin 
        end
        if_notsmall = true in ifVec

        if if_notsmall && if_close
            push!(marked_cells, cellid)
        end
    end

    FerriteAMR.refine!(forest,marked_cells)
    FerriteAMR.balanceforest!(forest;corner_balance=true)

    ifrefine = length(marked_cells) > 0

    return ifrefine
end

function solve()
    
    interpolation = Lagrange{RefQuadrilateral, 1}()

    # Generate a grid ...
    geometry = get_geometry(interpolation)
    interpolation_geo = interpolation
    N = get_N(interpolation)

    grid_ini = get_ferrite_grid("example/kwp.inp");
    adaptive_grid = ForestBWG(grid_ini,15)

    # ... a suitable quadrature rule ...
    qr_order = get_quadrature_order(interpolation)
    qr = QuadratureRule{Ferrite.getrefshape(interpolation)}(qr_order)
    
    # 
    pvd = paraview_collection("example/kwp_test")

    i = 0

    if_refine = true

    region_func = reg_fun(x) = abs(x[2]-25.0) < 0.25 && abs(x[1]-50.0) < 0.25

    while if_refine && i < 20

        grid_transfered = FerriteAMR.creategrid(adaptive_grid)

        dh, vertexdicts, cellvalues = setup_poisson_problem(grid_transfered, interpolation, interpolation_geo, qr)
        
        if_refine = check_and_compute_convergence(dh, cellvalues, adaptive_grid; lmin=0.05, region_func=region_func)

        VTKGridFile("example/kwp_test_$(i).vtu", dh) do vtk
            pvd[i] = vtk
        end
        i += 1
        @info i
    end

    vtk_save(pvd);
end

solve()

