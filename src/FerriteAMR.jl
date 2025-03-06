module FerriteAMR

using  Ferrite
import Ferrite: @debug
using  SparseArrays
using  OrderedCollections
using  WriteVTK

include("BWG.jl")
include("ncgrid.jl")
include("constraints.jl")
include("export.jl")

export  ForestBWG,
        refine!,
        refine_all!,
        coarsen!,
        balanceforest!,
        creategrid,
        ConformityConstraint,
        NonConformingGrid

end
