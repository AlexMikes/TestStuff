using GLVisualize, GeometryTypes, GLAbstraction, Colors

# if !isdefined(:runtests)
# 	window = glscreen()
# end


include(s"C:\Users\mikesa\github\fields\GraphSynth\module.jl")

using(GraphSynth)

adj = [0 1 0; 1 0 1; 0 1 0]
bidgf = GraphSynth.BlendedInverseGDFactory()
g = GraphSynth.Graph(adj)
GraphSynth.RegisterDisplayFactory(g, bidgf)

nodeCoords = [0.0 50.0 0.0; 50.0 50.0 0.0; 100.0 0.0 0.0]
for i=1:3
  g.nodes[i].coordinates = nodeCoords[i,:]
end

smooths = [0.01 0.01 0.01]
radii = [.5 .5 .5]
for i=1:3
  GraphSynth.setVariable!(g.nodes[i],smooths[i])
  GraphSynth.setVariable!(g.nodes[i],radii[i],2)
end





# if !isdefined(:runtests)
# 	renderloop(window)
# end

GraphSynth.plotLevelSet(g, 0.9)
