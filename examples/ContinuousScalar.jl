using IncrementalInference
using RoMEPlotting

# Start with an empty factor graph
fg = initfg()

# add the first node
addVariable!(fg, :x0, ContinuousScalar)

# this is unary (prior) factor and does not immediately trigger autoinit of :x0.
addFactor!(fg, [:x0], Prior(Normal(0, 1)))

@show isInitialized(fg, :x0) # false

addVariable!(fg, :x1, ContinuousScalar)
# P(Z | :x1 - :x0 ) where Z ~ Normal(10,1)
addFactor!(fg, [:x0, :x1], LinearRelative(Normal(10.0, 1)))
@show isInitialized(fg, :x0) # true

@show isInitialized(fg, :x1) # false

plotKDE(fg, :x0)
initAll!(fg)
plotKDE(fg, [:x0, :x1])

addVariable!(fg, :x2, ContinuousScalar)
mmo = Mixture(LinearRelative,
    (hypo1=Rayleigh(3), hypo2=Uniform(30, 55)),
    [0.4; 0.6])
addFactor!(fg, [:x1, :x2], mmo)

initAll!(fg)
plotKDE(fg, [:x0, :x1, :x2])

addVariable!(fg, :x3, ContinuousScalar)
addFactor!(fg, [:x2, :x3], LinearRelative(Normal(-50, 1)))

initAll!(fg)
plotKDE(fg, [:x0, :x1, :x2, :x3])

addFactor!(fg, [:x3, :x0], LinearRelative(Normal(40, 1)))

drawGraph(fg, show=true)

tree = solveTree!(fg)

# and visualization
plotKDE(fg, [:x0, :x1, :x2, :x3])