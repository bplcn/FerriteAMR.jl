@testset "OctantBWG Lookup Tables" begin
    @test FerriteAMR._face(1) == [3,5]
    @test FerriteAMR._face(5) == [1,5]
    @test FerriteAMR._face(12) == [2,4]
    @test FerriteAMR._face(1,1) == 3  && FerriteAMR._face(1,2) == 5
    @test FerriteAMR._face(5,1) == 1  && FerriteAMR._face(5,2) == 5
    @test FerriteAMR._face(12,1) == 2 && FerriteAMR._face(12,2) == 4
    @test FerriteAMR._face(3,1) == 3  && FerriteAMR._face(3,2) == 6

    @test FerriteAMR._face_edge_corners(1,1) == (0,0)
    @test FerriteAMR._face_edge_corners(3,3) == (3,4)
    @test FerriteAMR._face_edge_corners(8,6) == (2,4)
    @test FerriteAMR._face_edge_corners(4,5) == (0,0)
    @test FerriteAMR._face_edge_corners(5,4) == (0,0)
    @test FerriteAMR._face_edge_corners(7,1) == (3,4)
    @test FerriteAMR._face_edge_corners(11,1) == (2,4)
    @test FerriteAMR._face_edge_corners(9,1) == (1,3)
    @test FerriteAMR._face_edge_corners(10,2) == (1,3)
    @test FerriteAMR._face_edge_corners(12,2) == (2,4)

    @test FerriteAMR.𝒱₃[1,:] == FerriteAMR.𝒰[1:4,1] == FerriteAMR._face_corners(3,1)
    @test FerriteAMR.𝒱₃[2,:] == FerriteAMR.𝒰[1:4,2] == FerriteAMR._face_corners(3,2)
    @test FerriteAMR.𝒱₃[3,:] == FerriteAMR.𝒰[5:8,1] == FerriteAMR._face_corners(3,3)
    @test FerriteAMR.𝒱₃[4,:] == FerriteAMR.𝒰[5:8,2] == FerriteAMR._face_corners(3,4)
    @test FerriteAMR.𝒱₃[5,:] == FerriteAMR.𝒰[9:12,1] == FerriteAMR._face_corners(3,5)
    @test FerriteAMR.𝒱₃[6,:] == FerriteAMR.𝒰[9:12,2] == FerriteAMR._face_corners(3,6)

    @test FerriteAMR._edge_corners(1) == [1,2]
    @test FerriteAMR._edge_corners(4) == [7,8]
    @test FerriteAMR._edge_corners(12,2) == 8

    #Test Figure 3a) of Burstedde, Wilcox, Ghattas [2011]
    test_ξs = (1,2,3,4)
    @test FerriteAMR._neighbor_corner.((1,),(2,),(1,),test_ξs) == test_ξs
    #Test Figure 3b)
    @test FerriteAMR._neighbor_corner.((3,),(5,),(3,),test_ξs) == (FerriteAMR.𝒫[5,:]...,)
end

@testset "Index Permutation" begin
    for i in 1:length(FerriteAMR.edge_perm)
        @test i == FerriteAMR.edge_perm_inv[FerriteAMR.edge_perm[i]]
    end
    for i in 1:length(FerriteAMR.𝒱₂_perm)
        @test i == FerriteAMR.𝒱₂_perm_inv[FerriteAMR.𝒱₂_perm[i]]
    end
    for i in 1:length(FerriteAMR.𝒱₃_perm)
        @test i == FerriteAMR.𝒱₃_perm_inv[FerriteAMR.𝒱₃_perm[i]]
    end
    for i in 1:length(FerriteAMR.node_map₂)
        @test i == FerriteAMR.node_map₂_inv[FerriteAMR.node_map₂[i]]
    end
    for i in 1:length(FerriteAMR.node_map₃)
        @test i == FerriteAMR.node_map₃_inv[FerriteAMR.node_map₃[i]]
    end
end

@testset "OctantBWG Encoding" begin
#    # Tests from Figure 3a) and 3b) of Burstedde et al
    o = FerriteAMR.FerriteAMR.OctantBWG(3,2,21,3)
    b = 3
    @test FerriteAMR.child_id(o,b) == 5
    @test FerriteAMR.child_id(FerriteAMR.parent(o,b),b) == 3
    @test FerriteAMR.parent(FerriteAMR.parent(o,b),b) == FerriteAMR.OctantBWG(3,0,1,b)
    @test FerriteAMR.parent(FerriteAMR.parent(FerriteAMR.parent(o,b),b),b) == FerriteAMR.root(3)
    o = FerriteAMR.OctantBWG(3,2,4,3)
    @test FerriteAMR.child_id(o,b) == 4
    @test FerriteAMR.child_id(FerriteAMR.parent(o,b),b) == 1
    @test FerriteAMR.parent(FerriteAMR.parent(o,b),b) == FerriteAMR.OctantBWG(3,0,1,b)
    @test FerriteAMR.parent(FerriteAMR.parent(FerriteAMR.parent(o,b),b),b) == FerriteAMR.root(3)

    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(2,1,1,3),3) == 1
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(2,1,2,3),3) == 2
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(2,1,3,3),3) == 3
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(2,1,4,3),3) == 4
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(2,2,1,3),3) == 1
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,1,3),3) == 1
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,2,3),3) == 2
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,3,3),3) == 3
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,4,3),3) == 4
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,16,3),3) == 8
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,24,3),3) == 8
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,64,3),3) == 8
    @test FerriteAMR.child_id(FerriteAMR.OctantBWG(3,2,9,3),3) == 1
    #maxlevel = 10 takes too long
    maxlevel = 6
    levels = collect(1:maxlevel)
    morton_ids = [1:2^(2*l) for l in levels]
    for (level,morton_range) in zip(levels,morton_ids)
        for morton_id in morton_range
            @test Int(FerriteAMR.morton(FerriteAMR.OctantBWG(2,level,morton_id,maxlevel),level,maxlevel)) == morton_id
        end
    end
    morton_ids = [1:2^(3*l) for l in levels]
    for (level,morton_range) in zip(levels,morton_ids)
        for morton_id in morton_range
            @test Int(FerriteAMR.morton(FerriteAMR.OctantBWG(3,level,morton_id,maxlevel),level,maxlevel)) == morton_id
        end
    end
end

@testset "OctantBWG Operations" begin
    o = FerriteAMR.OctantBWG(1,(2,0,0))
    @test FerriteAMR.facet_neighbor(o,1,2) == FerriteAMR.OctantBWG(1,(0,0,0))
    @test FerriteAMR.facet_neighbor(o,2,2) == FerriteAMR.OctantBWG(1,(4,0,0))
    @test FerriteAMR.facet_neighbor(o,3,2) == FerriteAMR.OctantBWG(1,(2,-2,0))
    @test FerriteAMR.facet_neighbor(o,4,2) == FerriteAMR.OctantBWG(1,(2,2,0))
    @test FerriteAMR.facet_neighbor(o,5,2) == FerriteAMR.OctantBWG(1,(2,0,-2))
    @test FerriteAMR.facet_neighbor(o,6,2) == FerriteAMR.OctantBWG(1,(2,0,2))
    @test FerriteAMR.descendants(o,2) == (FerriteAMR.OctantBWG(2,(2,0,0)), FerriteAMR.OctantBWG(2,(3,1,1)))
    @test FerriteAMR.descendants(o,3) == (FerriteAMR.OctantBWG(3,(2,0,0)), FerriteAMR.OctantBWG(3,(5,3,3)))

    o = FerriteAMR.OctantBWG(1,(0,0,0))
    @test FerriteAMR.facet_neighbor(o,1,2) == FerriteAMR.OctantBWG(1,(-2,0,0))
    @test FerriteAMR.facet_neighbor(o,2,2) == FerriteAMR.OctantBWG(1,(2,0,0))
    @test FerriteAMR.facet_neighbor(o,3,2) == FerriteAMR.OctantBWG(1,(0,-2,0))
    @test FerriteAMR.facet_neighbor(o,4,2) == FerriteAMR.OctantBWG(1,(0,2,0))
    @test FerriteAMR.facet_neighbor(o,5,2) == FerriteAMR.OctantBWG(1,(0,0,-2))
    @test FerriteAMR.facet_neighbor(o,6,2) == FerriteAMR.OctantBWG(1,(0,0,2))
    o = FerriteAMR.OctantBWG(0,(0,0,0))
    @test FerriteAMR.descendants(o,2) == (FerriteAMR.OctantBWG(2,(0,0,0)), FerriteAMR.OctantBWG(2,(3,3,3)))
    @test FerriteAMR.descendants(o,3) == (FerriteAMR.OctantBWG(3,(0,0,0)), FerriteAMR.OctantBWG(3,(7,7,7)))

    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),1,3) == FerriteAMR.OctantBWG(2,(2,-2,-2))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),4,3) == FerriteAMR.OctantBWG(2,(2,2,2))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),6,3) == FerriteAMR.OctantBWG(2,(4,0,-2))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),9,3) == FerriteAMR.OctantBWG(2,(0,-2,0))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),12,3) == FerriteAMR.OctantBWG(2,(4,2,0))

    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(3,(0,0,0)),1,4)  == FerriteAMR.OctantBWG(3,(0,-2,-2))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(3,(0,0,0)),12,4) == FerriteAMR.OctantBWG(3,(2,2,0))

    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),1,4)  == FerriteAMR.OctantBWG(2,(0,-4,-4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),2,4)  == FerriteAMR.OctantBWG(2,(0,4,-4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),3,4)  == FerriteAMR.OctantBWG(2,(0,-4,4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),4,4)  == FerriteAMR.OctantBWG(2,(0,4,4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),5,4)  == FerriteAMR.OctantBWG(2,(-4,0,-4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),6,4)  == FerriteAMR.OctantBWG(2,(4,0,-4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),7,4)  == FerriteAMR.OctantBWG(2,(-4,0,4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),8,4)  == FerriteAMR.OctantBWG(2,(4,0,4))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),9,4)  == FerriteAMR.OctantBWG(2,(-4,-4,0))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),10,4)  == FerriteAMR.OctantBWG(2,(4,-4,0))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),11,4)  == FerriteAMR.OctantBWG(2,(-4,4,0))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(2,(0,0,0)),12,4) == FerriteAMR.OctantBWG(2,(4,4,0))

    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(1,(0,0,0)),1,4)  == FerriteAMR.OctantBWG(1,(0,-8,-8))
    @test FerriteAMR.edge_neighbor(FerriteAMR.OctantBWG(1,(0,0,0)),12,4) == FerriteAMR.OctantBWG(1,(8,8,0))

    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),1,3) == FerriteAMR.OctantBWG(2,(0,-2,-2))
    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),4,3) == FerriteAMR.OctantBWG(2,(4,2,-2))
    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0,0)),8,3) == FerriteAMR.OctantBWG(2,(4,2,2))

    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0)),1,3) == FerriteAMR.OctantBWG(2,(0,-2))
    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0)),2,3) == FerriteAMR.OctantBWG(2,(4,-2))
    @test FerriteAMR.corner_neighbor(FerriteAMR.OctantBWG(2,(2,0)),4,3) == FerriteAMR.OctantBWG(2,(4,2))
end

@testset "OctreeBWG Operations" begin
    # maximum level == 3
    # Octant level 0 size == 2^3=8
    # Octant level 1 size == 2^3/2 = 4
    # Octant level 2 size == 2^3/2 = 2
    # Octant level 3 size == 2^3/2 = 1
    # test translation constructor
    grid = generate_grid(Quadrilateral,(2,2))
    # Rotate face topologically
    grid.cells[2] = Quadrilateral((grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[1]))
    # This is our root mesh
    # x-----------x-----------x
    # |4    4    3|4    4    3|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|1    |    2|
    # |     +-->  |     +-->  |
    # |           |           |
    # |1    3    2|1    3    2|
    # x-----------x-----------x
    # |4    4    3|3    2    2|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|4    |    3|
    # |     +-->  |  <--+     |
    # |           |           |
    # |1    3    2|4    1    1|
    # x-----------x-----------x
    adaptive_grid = ForestBWG(grid,3)
    for cell in adaptive_grid.cells
        @test cell isa FerriteAMR.OctreeBWG
        @test cell.leaves[1] == FerriteAMR.OctantBWG(2,0,1,cell.b)
    end
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,2), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(4,1), adaptive_grid.cells[3].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(3,2), adaptive_grid.cells[4].leaves[1]) == FerriteAMR.OctantBWG(0,(-8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,4), adaptive_grid.cells[3].leaves[1]) == FerriteAMR.OctantBWG(0,(0,-8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(4,3), adaptive_grid.cells[2].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(2,2), adaptive_grid.cells[4].leaves[1]) == FerriteAMR.OctantBWG(0,(0,-8))
    o = adaptive_grid.cells[1].leaves[1]
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,4), o) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), o) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), o) == FerriteAMR.OctantBWG(0,(0,-8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(4,1), o) == FerriteAMR.OctantBWG(0,(-8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(4,3), o) == FerriteAMR.OctantBWG(0,(0,-8))

    grid_new = FerriteAMR.creategrid(adaptive_grid)
    @test length(grid_new.nodes) == 9
    @test length(grid_new.conformity_info) == 0

    grid.cells[4] = Quadrilateral((grid.cells[4].nodes[2], grid.cells[4].nodes[3], grid.cells[4].nodes[4], grid.cells[4].nodes[1]))
    grid.cells[4] = Quadrilateral((grid.cells[4].nodes[2], grid.cells[4].nodes[3], grid.cells[4].nodes[4], grid.cells[4].nodes[1]))
    # root mesh in FerriteAMR notation                        in p4est notation
    # x-----------x-----------x                         x-----------x-----------x
    # |4    3    3|2    1    1|                         |3    4    4|2    3    1|
    # |           |           |                         |           |           |
    # |     ^     |  <--+     |                         |     ^     |  <--+     |
    # |4    |    2|2    |    4|                         |1    |    2|2    |    1|
    # |     +-->  |     v     |                         |     +-->  |     v     |
    # |           |           |                         |           |           |
    # |1    1    2|3    3    4|                         |1    3    2|4    4    3|
    # x-----------x-----------x                         x-----------x-----------x
    # |4    3    3|3    2    2|                         |3    4    4|4    4    1|
    # |           |           |                         |           |           |
    # |     ^     |     ^     |                         |     ^     |     ^     |
    # |4    |    2|3    |    1|                         |1    |    2|2    |    1|
    # |     +-->  |  <--+     |                         |     +-->  |  <--+     |
    # |           |           |                         |           |           |
    # |1    1    2|4    4    1|                         |1    3    2|3    3    1|
    # x-----------x-----------x                         x-----------x-----------x
    adaptive_grid = ForestBWG(grid,3)
    for cell in adaptive_grid.cells
        @test cell isa FerriteAMR.OctreeBWG
        @test cell.leaves[1] == FerriteAMR.OctantBWG(2,0,1,cell.b)
    end
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,2), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(4,2), adaptive_grid.cells[3].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(3,2), adaptive_grid.cells[4].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[1]) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,4), adaptive_grid.cells[3].leaves[1]) == FerriteAMR.OctantBWG(0,(0,-8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(4,4), adaptive_grid.cells[2].leaves[1]) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(2,2), adaptive_grid.cells[4].leaves[1]) == FerriteAMR.OctantBWG(0,(0,8))

    #@test FerriteAMR.transform_corner(adaptive_grid, VertexIndex(4,4), adaptive_grid.cells[1].leaves[1],false) == FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,4), adaptive_grid.cells[1].leaves[1], false) == FerriteAMR.OctantBWG(0,(8,8))
    #@test FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(3,2), adaptive_grid.cells[1].leaves[1], false) == FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(2,4), adaptive_grid.cells[1].leaves[1], false) == FerriteAMR.OctantBWG(0,(8,-8))
    #@test FerriteAMR.transform_corner(adaptive_grid, VertexIndex(4,4), adaptive_grid.cells[1].leaves[1],false) == FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,4), adaptive_grid.cells[1].leaves[1],false) == FerriteAMR.OctantBWG(0,(8,8))
    #@test FerriteAMR.transform_corner(adaptive_grid, VertexIndex(3,2), adaptive_grid.cells[1].leaves[1], false) == FerriteAMR.transform_corner(adaptive_grid, VertexIndex(2,4), adaptive_grid.cells[1].leaves[1], false) == FerriteAMR.OctantBWG(0,(8,-8))

    o = adaptive_grid.cells[1].leaves[1]
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,4), o) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), o) == FerriteAMR.OctantBWG(0,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), o) == FerriteAMR.OctantBWG(0,(0,-8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(4,2), o) == FerriteAMR.OctantBWG(0,(8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(4,4), o) == FerriteAMR.OctantBWG(0,(0,8))


    #simple first and second level refinement
    # first case
    # x-----------x-----------x
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # x-----x-----x-----------x
    # |     |     |           |
    # |     |     |           |
    # |     |     |           |
    # x--x--x-----x           |
    # |  |  |     |           |
    # x--x--x     |           |
    # |  |  |     |           |
    # x--x--x-----x-----------x
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    @test length(adaptive_grid.cells[1].leaves) == 4
    for (m,octant) in zip(1:4,adaptive_grid.cells[1].leaves)
        @test octant == FerriteAMR.OctantBWG(2,1,m,adaptive_grid.cells[1].b)
    end
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])

    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[5]) == FerriteAMR.OctantBWG(1,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[7]) == FerriteAMR.OctantBWG(1,(4,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[6]) == FerriteAMR.OctantBWG(1,(0,-4))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[7]) == FerriteAMR.OctantBWG(1,(4,-4))

    grid_new = FerriteAMR.creategrid(adaptive_grid)
    @test length(grid_new.nodes) == 19
    @test length(grid_new.conformity_info) == 4

    # octree holds now 3 first level and 4 second level
    @test length(adaptive_grid.cells[1].leaves) == 7
    for (m,octant) in zip(1:4,adaptive_grid.cells[1].leaves)
        @test octant == FerriteAMR.OctantBWG(2,2,m,adaptive_grid.cells[1].b)
    end


    # second case
    # x-----------x-----------x
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # x-----x--x--x-----------x
    # |     |  |  |           |
    # |     x--x--x           |
    # |     |  |  |           |
    # x-----x--x--x           |
    # |     |     |           |
    # |     |     |           |
    # x-----x-----x-----------x
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    @test length(adaptive_grid.cells[1].leaves) == 7
    @test all(getproperty.(adaptive_grid.cells[1].leaves[1:3],:l) .== 1)

    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[2]) == FerriteAMR.OctantBWG(1,(0,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[5]) == FerriteAMR.OctantBWG(2,(4,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(2,4), adaptive_grid.cells[1].leaves[7]) == FerriteAMR.OctantBWG(2,(6,8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[3]) == FerriteAMR.OctantBWG(1,(0,-4))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[6]) == FerriteAMR.OctantBWG(2,(4,-2))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(3,3), adaptive_grid.cells[1].leaves[7]) == FerriteAMR.OctantBWG(2,(6,-2))

    grid_new = FerriteAMR.creategrid(adaptive_grid)
    @test length(grid_new.nodes) == 19
    @test length(grid_new.conformity_info) == 4
    
    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function generate_simple_disc_grid(::Type{Quadrilateral}, n; radius= 1.0)
        nnodes = 2n + 1
        θ = deg2rad(360/2n)
        
        nodepos = Vec((0.0,radius))
        nodes = [rotate(nodepos, θ*i) for i ∈ 0:(2n-1)]
        push!(nodes, Vec((0.0,0.0)))
        
        elements = Quadrilateral[Quadrilateral((2i-1==0 ? nnodes-1 : 2i-1,2i,2i+1 == nnodes ? 1 : 2i+1,nnodes)) for i ∈ 1:n]
        
        facetsets = Dict(
            "boundary" => OrderedSet([FacetIndex(i,1) for i ∈ 1:n]) ∪ OrderedSet([FacetIndex(i,2) for i ∈ 1:n]),
            )
            
        return Grid(elements, Node.(nodes); facetsets=facetsets)
    end
    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # 

    # more complex neighborhoods
    grid = generate_simple_disc_grid(Quadrilateral, 6)
    grid.cells[2] = Quadrilateral((grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[1]))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[3],adaptive_grid.cells[3].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[5],adaptive_grid.cells[5].leaves[1])

    grid_new = FerriteAMR.creategrid(adaptive_grid)
    @test length(grid_new.nodes) == 23
    @test length(grid_new.conformity_info) == 4

    ##################################################################
    ####uniform refinement and coarsening for all cells and levels####
    ##################################################################
    adaptive_grid = ForestBWG(grid,8)
    for l in 1:8
        FerriteAMR.refine_all!(adaptive_grid,l)
        for tree in adaptive_grid.cells
            @test all(FerriteAMR.morton.(tree.leaves,l,8) == collect(1:2^(2*l)))
        end
    end
    #check montonicity of ancestor_id
    for tree in adaptive_grid.cells
        ids = FerriteAMR.ancestor_id.(tree.leaves,(1,),(tree.b,))
        @test issorted(ids)
    end
    #now go back from finest to coarsest
    for l in 7:-1:0
        FerriteAMR.coarsen_all!(adaptive_grid)
        for tree in adaptive_grid.cells
            @test all(FerriteAMR.morton.(tree.leaves,l,8) == collect(1:2^(2*l)))
        end
    end
    #########################
    # now do the same with 3D
    # some ascii picasso can insert here something beautiful
    #########################
    # TODO add some test with higher refinement level which failed in my REPl (I think 8 should fail)
    # TODO add some rotation and more elaborate case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    o = adaptive_grid.cells[1].leaves[1]

    # faces
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,2), o) == FerriteAMR.OctantBWG(0,(8,0,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,2), o) == FerriteAMR.OctantBWG(0,(-8,0,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,4), o) == FerriteAMR.OctantBWG(0,(0,8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,4), o) == FerriteAMR.OctantBWG(0,(0,-8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,6), o) == FerriteAMR.OctantBWG(0,(0,0,8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,6), o) == FerriteAMR.OctantBWG(0,(0,0,-8))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,1), o) == FerriteAMR.OctantBWG(0,(-8,0,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,1), o) == FerriteAMR.OctantBWG(0,(8,0,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,3), o) == FerriteAMR.OctantBWG(0,(0,-8,0))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,3), o) == FerriteAMR.OctantBWG(0,(0,8,0))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,5), o) == FerriteAMR.OctantBWG(0,(0,0,-8))
    @test FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,5), o) == FerriteAMR.OctantBWG(0,(0,0,8))

    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,1), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,1), o)
    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,3), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,3), o)
    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,5), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(1,5), o)
    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,2), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,2), o)
    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,4), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,4), o)
    @test_throws BoundsError FerriteAMR.transform_facet(adaptive_grid, FacetIndex(8,6), o)
    @test_throws BoundsError FerriteAMR.transform_facet_remote(adaptive_grid, FacetIndex(8,6), o)

    #corners
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,1), o, false) == FerriteAMR.OctantBWG(0,(-8,-8,-8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,2), o, false) == FerriteAMR.OctantBWG(0,(8,-8,-8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,3), o, false) == FerriteAMR.OctantBWG(0,(-8,8,-8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,4), o, false) == FerriteAMR.OctantBWG(0,(8,8,-8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,5), o, false) == FerriteAMR.OctantBWG(0,(-8,-8,8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,6), o, false) == FerriteAMR.OctantBWG(0,(8,-8,8))
    @test_throws BoundsError FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,7), o, false) == FerriteAMR.OctantBWG(0,(-8,8,8))
    @test FerriteAMR.transform_corner(adaptive_grid, VertexIndex(1,8), o, false) == FerriteAMR.OctantBWG(0,(8,8,8))
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,1), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,2), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,3), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,4), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,5), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,6), o, false)
    @test_throws BoundsError FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,7), o, false)
    FerriteAMR.transform_corner_remote(adaptive_grid, VertexIndex(1,8), o, false) == FerriteAMR.OctantBWG(0,(-8,-8,-8))

    #edges
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,1), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,2), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,3), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,1), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,2), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,3), o, false)
    @test FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,4), o, false) == FerriteAMR.OctantBWG(0,(0,8,8))
    @test FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,4), o, false) == FerriteAMR.OctantBWG(0,(0,-8,-8))
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,5), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,6), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,7), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,5), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,6), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,7), o, false)
    @test FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,8), o, false) == FerriteAMR.OctantBWG(0,(8,0,8))
    @test FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,8), o, false) == FerriteAMR.OctantBWG(0,(-8,0,-8))
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,9), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,10), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,11), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,9), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,10), o, false)
    @test_throws BoundsError FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,11), o, false)
    @test FerriteAMR.transform_edge(adaptive_grid, EdgeIndex(1,12), o, false) == FerriteAMR.OctantBWG(0,(8,8,0))
    @test FerriteAMR.transform_edge_remote(adaptive_grid, EdgeIndex(1,12), o, false) == FerriteAMR.OctantBWG(0,(-8,-8,0))

    # Rotate three dimensional case
    # This is our root mesh top view
    # x-----------x-----------x
    # |6    3    5|8    4    7|
    # |           |           |
    # |     ^     |     ^     |
    # |2    |    1|1    |    2|
    # |  <--+     |     +-->  |
    # |           |           |
    # |7    4    8|5    3    6|
    # x-----------x-----------x
    # |8    4    7|8    4    7|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|1    |    2|
    # |     +-->  |     +-->  |
    # |           |           |
    # |5    3    6|5    3    6|
    # x-----------x-----------x
    grid = generate_grid(Hexahedron,(2,2,2))
    # Rotate face topologically as decscribed in the ascii picture above
    grid.cells[7] = Hexahedron((grid.cells[7].nodes[2], grid.cells[7].nodes[3], grid.cells[7].nodes[4], grid.cells[7].nodes[1], grid.cells[7].nodes[4+2], grid.cells[7].nodes[4+3], grid.cells[7].nodes[4+4], grid.cells[7].nodes[4+1]))
    grid.cells[7] = Hexahedron((grid.cells[7].nodes[2], grid.cells[7].nodes[3], grid.cells[7].nodes[4], grid.cells[7].nodes[1], grid.cells[7].nodes[4+2], grid.cells[7].nodes[4+3], grid.cells[7].nodes[4+4], grid.cells[7].nodes[4+1]))
    adaptive_grid = ForestBWG(grid,3)
    @test FerriteAMR.transform_corner(adaptive_grid,7,3,FerriteAMR.OctantBWG(0,(0,0,0)),false) == FerriteAMR.OctantBWG(0,(-8,8,-8))

    #refinement
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    @test length(adaptive_grid.cells[1].leaves) == 8
    for (m,octant) in zip(1:8,adaptive_grid.cells[1].leaves)
        @test octant == FerriteAMR.OctantBWG(3,1,m,adaptive_grid.cells[1].b)
    end
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    @test length(adaptive_grid.cells[1].leaves) == 15
    for (m,octant) in zip(1:8,adaptive_grid.cells[1].leaves)
        @test octant == FerriteAMR.OctantBWG(3,2,m,adaptive_grid.cells[1].b)
    end
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    @test length(adaptive_grid.cells[1].leaves) == 15
    @test all(getproperty.(adaptive_grid.cells[1].leaves[1:3],:l) .== 1)
    @test all(getproperty.(adaptive_grid.cells[1].leaves[4:11],:l) .== 2)
    @test all(getproperty.(adaptive_grid.cells[1].leaves[12:end],:l) .== 1)
    adaptive_grid = ForestBWG(grid,5)
    #go from coarsest to finest uniformly
    for l in 1:5
        FerriteAMR.refine_all!(adaptive_grid,l)
        for tree in adaptive_grid.cells
            @test all(FerriteAMR.morton.(tree.leaves,l,5) == collect(1:2^(3*l)))
        end
    end
    #now go back from finest to coarsest
    for l in 4:-1:0
        FerriteAMR.coarsen_all!(adaptive_grid)
        for tree in adaptive_grid.cells
            @test all(FerriteAMR.morton.(tree.leaves,l,5) == collect(1:2^(3*l)))
        end
    end

    # Single
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[8])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    # Unrefined grid has 5 ^ dim nodes and the refined element introduces 6 face center, 12 edge center and 1 volume center nodes
    @test length(transfered_grid.nodes) == 5^3 + (6 + 12 + 1)
    # 6 faces and 12 edges of the single refined element induces one hanging node each
    @test length(transfered_grid.conformity_info) == 6 + 12

    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    # Unrefined grid has 5 ^ dim nodes and the refined element introduces 6 face center, 12 edge center and 1 volume center nodes
    @test length(transfered_grid.nodes) == 5^3 + (6 + 12 + 1)
    # 6 faces and 12 edges of the single refined element induces one hanging node each - minus 3 faces and 3 edges on the outer boundary
    @test length(transfered_grid.conformity_info) == 6 + 12- 2*3

    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[8])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
     # Unrefined grid has 5 ^ dim nodes and the refined element introduces 6 face center, 12 edge center and 1 volume center nodes
     @test length(transfered_grid.nodes) == 5^3 + (6 + 12 + 1)
     # 6 faces and 12 edges of the single refined element induces one hanging node each - minus 3 faces and 3 edges on the outer boundary
    @test length(transfered_grid.conformity_info) == 6 + 12 - 2*3

    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    # Unrefined grid has 5 ^ dim nodes and the refined element introduces 6 face center, 12 edge center and 1 volume center nodes
    @test length(transfered_grid.nodes) == 5^3 + (6 + 12 + 1)
    # 6 faces and 12 edges of the single refined element induces one hanging node each
    @test length(transfered_grid.conformity_info) == 6 + 12

    # Combined
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    @test length(transfered_grid.nodes) == 5^3 + 2*(6 + 12 + 1)
    @test length(transfered_grid.conformity_info) == 2*(6 + 12) - 2*3

    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    @test length(transfered_grid.nodes) == 5^3 + 2*(6 + 12 + 1)
    @test length(transfered_grid.conformity_info) == 2*(6 + 12) - 2*3

    # Combined
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[8],adaptive_grid.cells[8].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    @test length(transfered_grid.nodes) == 5^3 + 4*(6 + 12 + 1)
    @test length(transfered_grid.conformity_info) == 4*(6 + 12) - 2*3 - 2*3

    # Combined and not rotated
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[6],adaptive_grid.cells[6].leaves[6])
    FerriteAMR.refine!(adaptive_grid.cells[6],adaptive_grid.cells[6].leaves[3])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    # +5^3 on the coarse grid
    # +4 refined elements a 6 face nodes, 12 edge nodes and 1 volume nodes
    # -1 shared node between tree 1 and 6
    @test length(transfered_grid.nodes) == 5^3 + 4*(6 + 12 + 1) - 1
    # 4*(6 + 12)    potential hanging nodes
    # - 2           shared through common edge
    # - 2* (2*3)    outer boundary face and edge nodes
    @test length(transfered_grid.conformity_info) == 4*(6 + 12) - 2 - 2*3 - 2*3

    # Combined and rotated
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[8])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[6])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[3])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    # +5^3 on the coarse grid
    # +4 refined elements a 6 face nodes, 12 edge nodes and 1 volume nodes
    # -1 shared node between tree 1 and 7
    @test length(transfered_grid.nodes) == 5^3 + 4*(6 + 12 + 1) - 1
    # 4*(6 + 12)    potential hanging nodes
    # - 2           shared through common edge
    # - 2* (2*3)    outer boundary face and edge nodes
    @test length(transfered_grid.conformity_info) == 4*(6 + 12) - 2 - 2*3 - 2*3

    # Reproducer test for Fig.3 BWG 11
    grid = generate_grid(Hexahedron,(2,1,1))
    # (a)
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[2],adaptive_grid.cells[2].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[2],adaptive_grid.cells[2].leaves[3])
    @test adaptive_grid.cells[2].leaves[3+4] == FerriteAMR.OctantBWG(2,(0,4,2))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,2), adaptive_grid.cells[2].leaves[3+4]) == FerriteAMR.OctantBWG(2,(8,4,2))
    # (b) Rotate elements topologically
    grid.cells[1] = Hexahedron((grid.cells[1].nodes[2], grid.cells[1].nodes[3], grid.cells[1].nodes[4], grid.cells[1].nodes[1], grid.cells[1].nodes[6], grid.cells[1].nodes[7], grid.cells[1].nodes[8], grid.cells[1].nodes[5]))
    grid.cells[2] = Hexahedron((grid.cells[2].nodes[4], grid.cells[2].nodes[1], grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[8], grid.cells[2].nodes[5], grid.cells[2].nodes[6], grid.cells[2].nodes[7]))
    # grid.cells[2] = Hexahedron((grid.cells[2].nodes[1], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[8], grid.cells[2].nodes[6], grid.cells[2].nodes[2], grid.cells[2].nodes[7], grid.cells[2].nodes[5])) How to rotate along diagonal? :)
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[2],adaptive_grid.cells[2].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[2],adaptive_grid.cells[2].leaves[1])
    @test adaptive_grid.cells[2].leaves[6] == FerriteAMR.OctantBWG(2,(2,0,2))
    @test FerriteAMR.transform_facet(adaptive_grid, FacetIndex(1,3), adaptive_grid.cells[2].leaves[6]) == FerriteAMR.OctantBWG(2,(4,-2,2))
end

@testset "ForestBWG AbstractGrid Interfacing" begin
    maxlevel = 3
    grid = generate_grid(Quadrilateral,(2,2))
    adaptive_grid = ForestBWG(grid,maxlevel)
    for l in 1:maxlevel
        FerriteAMR.refine_all!(adaptive_grid,l)
        @test getncells(adaptive_grid) == 2^(2*l) * 4 == length(getcells(adaptive_grid))
    end
end

@testset "Balancing" begin
    #2D cases
    #simple one quad with one additional non-allowed non-conformity level
    grid = generate_grid(Quadrilateral,(1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[6])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[6])
    balanced = FerriteAMR.balancetree(adaptive_grid.cells[1])
    @test length(balanced.leaves) == 16

    #more complex non-conformity level 3 and 4 that needs to be balanced
    adaptive_grid = ForestBWG(grid,5)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[7])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[12])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[12])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[15])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[16])
    balanced = FerriteAMR.balancetree(adaptive_grid.cells[1])
    @test length(balanced.leaves) == 64

    grid = generate_grid(Quadrilateral,(2,1))
    adaptive_grid = ForestBWG(grid,2)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 11

    grid = generate_grid(Quadrilateral,(2,2))
    adaptive_grid = ForestBWG(grid,2)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 19

    # 2D example with balancing over a corner connection that is not within the topology tables
    grid = generate_grid(Quadrilateral,(2,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[5])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 23

    #corner balance case but rotated
    grid = generate_grid(Quadrilateral,(2,1))
    grid.cells[1] = Quadrilateral((grid.cells[1].nodes[2], grid.cells[1].nodes[3], grid.cells[1].nodes[4], grid.cells[1].nodes[1]))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 23

    # 3D case intra treee simple test, non conformity level 2
    grid = generate_grid(Hexahedron,(1,1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[6])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[6])
    balanced = FerriteAMR.balancetree(adaptive_grid.cells[1])
    @test length(balanced.leaves) == 43

    #3D case intra tree non conformity level 3 at two different places
    adaptive_grid = ForestBWG(grid,4)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[7])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[12])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[28])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[29])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[37])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[39])
    balanced = FerriteAMR.balancetree(adaptive_grid.cells[1])
    @test length(balanced.leaves) == 127

    #3D case inter tree non conformity level 3 at two different places
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,4)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    #FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[7])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    #FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    transfered_grid_ref = FerriteAMR.creategrid(adaptive_grid)

    # Rotate three dimensional case
    grid = generate_grid(Hexahedron,(2,2,2))
    # This is our root mesh top view
    # x-----------x-----------x
    # |7    2    6|8    4    7|
    # |           |           |
    # |     ^     |     ^     |
    # |4    |    3|1    |    2|
    # |  <--+     |     +-->  |
    # |           |           |
    # |8    1    5|5    3    6|
    # x-----------x-----------x
    # |8    4    7|8    4    7|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|1    |    2|
    # |     +-->  |     +-->  |
    # |           |           |
    # |5    3    6|5    3    6|
    # x-----------x-----------x
    # Rotate face topologically
    grid.cells[7] = Hexahedron((grid.cells[7].nodes[2], grid.cells[7].nodes[3], grid.cells[7].nodes[4], grid.cells[7].nodes[1], grid.cells[7].nodes[4+2], grid.cells[7].nodes[4+3], grid.cells[7].nodes[4+4], grid.cells[7].nodes[4+1]))
    grid.cells[7] = Hexahedron((grid.cells[7].nodes[2], grid.cells[7].nodes[3], grid.cells[7].nodes[4], grid.cells[7].nodes[1], grid.cells[7].nodes[4+2], grid.cells[7].nodes[4+3], grid.cells[7].nodes[4+4], grid.cells[7].nodes[4+1]))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[4])
    #FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[7])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == length(transfered_grid_ref.cells)
    @test length(transfered_grid.cells) == 92

    # edge balancing for new introduced connection that is not within topology table
    grid = generate_grid(Hexahedron, (2,1,1));
    adaptive_grid  = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid, [1,2])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid, [4])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid, [5])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 51

    #another edge balancing case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid,1)
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid,[2,4,6,8])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid,34)
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 134

    #yet another edge balancing case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid,1)
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid,[2,4,6,8])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid,30)
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 120

    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 15

    #yet another edge balancing case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 43

    #yet another edge balancing case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid.cells[3],adaptive_grid.cells[3].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[10])
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[3])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 71

    #yet another edge balancing case
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[1])
    FerriteAMR.balanceforest!(adaptive_grid)
    FerriteAMR.refine!(adaptive_grid.cells[4],adaptive_grid.cells[4].leaves[7])
    FerriteAMR.balanceforest!(adaptive_grid)
    @test FerriteAMR.getncells(adaptive_grid) == 120
end

@testset "Materializing Grid" begin
    #################################################
    ############ structured 2D examples #############
    #################################################

    # 2D case with a single tree
    grid = generate_grid(Quadrilateral,(1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 10
    @test length(transfered_grid.nodes) == 19
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    #2D case with four trees and somewhat refinement pattern
    grid = generate_grid(Quadrilateral,(2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 22
    @test length(transfered_grid.nodes) == 35
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    #more random refinement
    grid = generate_grid(Quadrilateral,(3,3))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[3],adaptive_grid.cells[3].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[3],adaptive_grid.cells[3].leaves[2])
    FerriteAMR.refine!(adaptive_grid.cells[3],adaptive_grid.cells[3].leaves[3])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[3])
    FerriteAMR.refine!(adaptive_grid.cells[7],adaptive_grid.cells[7].leaves[5])
    FerriteAMR.refine!(adaptive_grid.cells[9],adaptive_grid.cells[9].leaves[end])
    FerriteAMR.refine!(adaptive_grid.cells[9],adaptive_grid.cells[9].leaves[end])
    FerriteAMR.refine!(adaptive_grid.cells[9],adaptive_grid.cells[9].leaves[end])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 45
    @test length(transfered_grid.nodes) == 76
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    #################################################
    ############ structured 3D examples #############
    #################################################

    # 3D case with a single tree
    grid = generate_grid(Hexahedron,(1,1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 8+7+7
    @test length(transfered_grid.nodes) == 65
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    # Test only Interoctree by face connection
    grid = generate_grid(Hexahedron,(2,1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 16
    @test length(transfered_grid.nodes) == 45
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    #rotate the case around
    grid = generate_grid(Hexahedron,(1,2,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 16
    @test length(transfered_grid.nodes) == 45
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    grid = generate_grid(Hexahedron,(1,1,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 16
    @test length(transfered_grid.nodes) == 45
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 8^2
    @test length(transfered_grid.nodes) == 125 # 5 per edge
    @test unique(transfered_grid.nodes) == transfered_grid.nodes

    # Rotate three dimensional case
    grid = generate_grid(Hexahedron,(2,2,2))
    # Rotate face topologically
    grid.cells[2] = Hexahedron((grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[1], grid.cells[2].nodes[4+2], grid.cells[2].nodes[4+3], grid.cells[2].nodes[4+4], grid.cells[2].nodes[4+1]))
    grid.cells[2] = Hexahedron((grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[1], grid.cells[2].nodes[4+2], grid.cells[2].nodes[4+3], grid.cells[2].nodes[4+4], grid.cells[2].nodes[4+1]))
    # This is our root mesh bottom view
    # x-----------x-----------x
    # |4    4    3|4    4    3|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|1    |    2|
    # |     +-->  |     +-->  |
    # |           |           |
    # |1    3    2|1    3    2|
    # x-----------x-----------x
    # |4    4    3|3    2    2|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|4    |    3|
    # |     +-->  |  <--+     |
    # |           |           |
    # |1    3    2|4    1    1|
    # x-----------x-----------x
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.cells) == 8^2
    @test length(transfered_grid.nodes) == 125 # 5 per edge
    @test unique(transfered_grid.nodes) == transfered_grid.nodes
    #TODO iterate over all rotated versions and check if det J > 0
end

@testset "hanging nodes" begin
    #Easy Intraoctree
    grid = generate_grid(Hexahedron,(1,1,1))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine_all!(adaptive_grid,1)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    # x-----------x-----------x
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # x-----x-----x-----------x
    # |     |     |           |
    # |     |     |           |
    # |     |     |           |
    # x-----x-----x           |
    # |     |     |           |
    # |     |     |           |
    # |     |     |           |
    # x-----x-----x-----------x
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.conformity_info) == 12

    # Easy Interoctree
    grid = generate_grid(Hexahedron,(2,2,2))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    # x-----------x-----------x
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # |           |           |
    # x-----x-----x-----------x
    # |     |     |           |
    # |     |     |           |
    # |     |     |           |
    # x-----x-----x           |
    # |     |     |           |
    # |     |     |           |
    # |     |     |           |
    # x-----x-----x-----------x
    transfered_grid = FerriteAMR.creategrid(adaptive_grid)
    @test length(transfered_grid.conformity_info) == 12

    #rotate the case from above in the first cell around
    grid = generate_grid(Hexahedron,(2,2,2))
    # Rotate face topologically
    grid.cells[1] = Hexahedron((grid.cells[1].nodes[2], grid.cells[1].nodes[3], grid.cells[1].nodes[4], grid.cells[1].nodes[1], grid.cells[1].nodes[4+2], grid.cells[1].nodes[4+3], grid.cells[1].nodes[4+4], grid.cells[1].nodes[4+1]))
    grid.cells[1] = Hexahedron((grid.cells[1].nodes[2], grid.cells[1].nodes[3], grid.cells[1].nodes[4], grid.cells[1].nodes[1], grid.cells[1].nodes[4+2], grid.cells[1].nodes[4+3], grid.cells[1].nodes[4+4], grid.cells[1].nodes[4+1]))
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    transfered_grid_rotated = FerriteAMR.creategrid(adaptive_grid)
    @test transfered_grid_rotated.conformity_info[5] == [28,25]
    @test transfered_grid_rotated.conformity_info[20] == [10,15]
    @test transfered_grid_rotated.conformity_info[30] == [15,18]
    @test transfered_grid_rotated.conformity_info[1] == [2,18]
    @test transfered_grid_rotated.conformity_info[19] == [16,28]
    @test transfered_grid_rotated.conformity_info[22] == [10,15,2,18]
    @test transfered_grid_rotated.conformity_info[41] == [10,16,2,28]
    @test transfered_grid_rotated.conformity_info[43] == [18,25]
    @test transfered_grid_rotated.conformity_info[11] == [10,2]
    @test transfered_grid_rotated.conformity_info[36] == [2,28]
    @test transfered_grid_rotated.conformity_info[40] == [10,16]
    @test transfered_grid_rotated.conformity_info[38] == [2,18,28,25]
    @test length(transfered_grid_rotated.conformity_info) == 12

    #2D rotated case
    grid = generate_grid(Quadrilateral,(2,2))
    # Rotate face topologically
    grid.cells[2] = Quadrilateral((grid.cells[2].nodes[2], grid.cells[2].nodes[3], grid.cells[2].nodes[4], grid.cells[2].nodes[1]))
    # This is our root mesh
    # x-----------x-----------x
    # |4    4    3|4    4    3|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|1    |    2|
    # |     +-->  |     +-->  |
    # |           |           |
    # |1    3    2|1    3    2|
    # x-----------x-----------x
    # |4    4    3|3    2    2|
    # |           |           |
    # |     ^     |     ^     |
    # |1    |    2|4    |    3|
    # |     +-->  |  <--+     |
    # |           |           |
    # |1    3    2|4    1    1|
    # x-----------x-----------x
    adaptive_grid = ForestBWG(grid,3)
    FerriteAMR.refine!(adaptive_grid.cells[2],adaptive_grid.cells[2].leaves[1])
    transfered_grid_rotated = FerriteAMR.creategrid(adaptive_grid)
    @test transfered_grid_rotated.conformity_info[11] == [1,7]
    @test transfered_grid_rotated.conformity_info[10] == [3,7]

    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function generate_simple_disc_grid(::Type{Quadrilateral}, n; radius= 1.0)
        nnodes = 2n + 1
        θ = deg2rad(360/2n)
        
        nodepos = Vec((0.0,radius))
        nodes = [rotate(nodepos, θ*i) for i ∈ 0:(2n-1)]
        push!(nodes, Vec((0.0,0.0)))
        
        elements = Quadrilateral[Quadrilateral((2i-1==0 ? nnodes-1 : 2i-1,2i,2i+1 == nnodes ? 1 : 2i+1,nnodes)) for i ∈ 1:n]
        
        facetsets = Dict(
            "boundary" => OrderedSet([FacetIndex(i,1) for i ∈ 1:n]) ∪ OrderedSet([FacetIndex(i,2) for i ∈ 1:n]),
            )
            
        return Grid(elements, Node.(nodes); facetsets=facetsets)
    end
    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # multiple corner connections in 2D by disc discretization
    grid = generate_simple_disc_grid(Quadrilateral,10)
    adaptive_grid = ForestBWG(grid,3)
    @test getncells(adaptive_grid) == 10
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[3])
    @test getncells(adaptive_grid) == 16
    FerriteAMR.balanceforest!(adaptive_grid)
    @test getncells(adaptive_grid) == 9*4 + 3 + 4


    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    function generate_simple_disc_grid(::Type{Hexahedron}, n; radius = 1.0, layers = 1, height = 1.0)
        nnodes = 2n + 1
        θ = deg2rad(360/2n)

        nodepos_bottom = Vec((0.0,radius,0.0))
        nodes = [rotate(nodepos_bottom, Vec{3}((0,0,1)), θ*i) for i ∈ 0:(2n-1)]
        push!(nodes, Vec((0.0,0.0,0.0)))

        # TODO generalize for n layers by looping over layers
        nodepos_layer  = Vec((0.0,radius,height))
        nodes_layer = [rotate(nodepos_layer, Vec{3}((0,0,1)), θ*i) for i ∈ 0:(2n-1)]
        push!(nodes_layer, Vec((0.0,0.0,1.0)))
        nodes = vcat(nodes,nodes_layer)

        elements = [Hexahedron((2i-1==0 ? nnodes-1 : 2i-1,2i,2i+1 == nnodes ? 1 : 2i+1,nnodes,2i-1==0 ? nnodes-1 : 2i-1+(2*n+1),2i+(2*n+1),2i+1 == nnodes ? (2*n+2) : 2i+1+(2*n+1),nnodes*(layers+1))) for i ∈ 1:n*layers]

        facesets = Dict(
            "side" => Set([FaceIndex(i,1) for i ∈ 1:n]) ∪ Set([FaceIndex(i,2) for i ∈ 1:n]),
            "top" => Set([FaceIndex(i,5) for i ∈ 1:n]),
            "bottom" => Set([FaceIndex(i,6) for i ∈ 1:n]),
        )

        return Grid(elements, Node.(nodes))#; facesets=facesets)
    end
    # ! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # multiple corner connections in 3D by cylinder discretization
    grid = generate_simple_disc_grid(Hexahedron,10)
    adaptive_grid = ForestBWG(grid,3)
    @test getncells(adaptive_grid) == 10
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[1])
    @test getncells(adaptive_grid) == 17
    FerriteAMR.refine!(adaptive_grid.cells[1],adaptive_grid.cells[1].leaves[3])
    @test getncells(adaptive_grid) == 24
    FerriteAMR.balanceforest!(adaptive_grid)
    @test getncells(adaptive_grid) == 9*8 + 7 + 8
end
