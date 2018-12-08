include("GraphSynth/module.jl");
#using(GraphSynth)
include("StructSynth/module.jl");
#using(StructSynth)
include("3DMoments/CalculateMoments.jl")
include("3DMoments/CalculateCellMoments.jl")
include("3DMoments/viewGridValues.jl")

# g = StructSynth.Run("", "2DKnearest\\top3D_result.csv")

x = Array{Any,1}(15);
x[1] = 2000
x[2] = 20    #r
x[3] = 2    # If a node has arcs that less than this number,it will be removed
x[4] = 15   # The maximum number of arcs that a node can have.
x[5] = [10,2]    #y
x[6] = [10,2]    #y
x[7] = [10,2]    #z
x[8] = 3.0  #e
x[9] = 3.0    #n
inputMoments = StructSynth.readMomentsFile("2DKnearest\\top3D_result.csv");
stressData = StructSynth.getStressFromFEA(inputMoments);
g = StructSynth.MakeGraph(x, inputMoments, stressData);

inputArgs = Dict{String, Any}("minCoord" => [0.0, 0.0, 0.0],"maxCoord" => [10.0, 30.0, 2.0],)
x[10] = 0.15 #node radius
x[11] = 0.0005 #node smoothness
x[12] = 0.15 #arc radius
x[13] = 0.0005 #arc smoothness
x[14] = 0.3 #cuttof level for the level set. If it is zero, then entire
#space will be full as the implicit function is only positive numbers. It
# might be nice to normalize s.t. the highest is 1, but this will take
#computational time
x[15] = 0.05 #the minimum contribution maybe should not be a decision variable
# it relates to the accuracy vs. time of calculating the function

bidgf = GraphSynth.BlendedInverseGDFactory(x[10],x[11],x[12],x[13],x[14])
rdgf = GraphSynth.RadialDistanceGDFactory()
# or rdgf = GraphSynth.RadialDistanceGDFactory()
GraphSynth.RegisterDisplayFactory(g, bidgf)


# minCoords=[0.0,0.0,0.0]
# maxCoords=[100.0,100.0,100.0]

order = 1
numVoxels = 5

# moments,gridValues,cellMoments = @enter CalculateMoments(g, minCoords, maxCoords, order, level)

 # moments,gridValues,cellMoments = CalculateMoments(g,inputArgs["minCoord"],inputArgs["maxCoord"],order)
moments =   CalculateMoments(g,inputArgs["minCoord"],inputArgs["maxCoord"],order,numVoxels)


# show(norm(moments))
viewGridValues(gridValues)
 # error = CalculateError
# (g::GraphSynth.Graph, minCoord::Array{Float64,1},maxCoord::Array{Float64,1}, order::Float64, level::Float64,scaling::Int64)

# StructSynth.plot_structure(g.arcs,0.1,0.1);
