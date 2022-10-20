
# tell Julia that you want to use these modules/namespaces
using RoME, Distributions, LinearAlgebra

# Inter-operating visualization packages for Caesar/RoME/IncrementalInference exist
using RoMEPlotting


# start with an empty factor graph object
fg = initfg()

# Add the first pose :x0
addVariable!(fg, :x0, Pose2)

# Add at a fixed location PriorPose2 to pin :x0 to a starting location
addFactor!(fg, [:x0], PriorPose2(MvNormal(zeros(3), 0.01 * Matrix(LinearAlgebra.I, 3, 3))))

# Drive around in a hexagon
for i in 0:5
    psym = Symbol("x$i")
    nsym = Symbol("x$(i+1)")
    addVariable!(fg, nsym, Pose2)
    pp = Pose2Pose2(MvNormal([10.0; 0; pi / 3], Matrix(Diagonal([0.1; 0.1; 0.1] .^ 2))))
    addFactor!(fg, [psym; nsym], pp)
end

drawGraph(fg)

# perform inference, and remember first runs are slower owing to Julia's just-in-time compiling
tree = solveTree!(fg)

getSolverParams(fg).drawtree = true
getSolverParams(fg).showtree = true

# For Juno/Jupyter style use
pl = plotSLAM2D(fg)

# For scripting use-cases you can export the image
pl |> Gadfly.PDF("/tmp/test.pdf") # or PNG(...)

# Add landmarks with Bearing range measurements
addVariable!(fg, :l1, Point2, tags=[:LANDMARK;])
p2br = Pose2Point2BearingRange(Normal(0, 0.1), Normal(20.0, 1.0))
addFactor!(fg, [:x0; :l1], p2br)

# Initialize :l1 numerical values but do not rerun solver
initAll!(fg)
pl = plotSLAM2D(fg)

p2br2 = Pose2Point2BearingRange(Normal(0, 0.1), Normal(20.0, 1.0))
addFactor!(fg, [:x6; :l1], p2br2)

# solve
tree = solveTree!(fg, tree)

# redraw
pl = plotSLAM2D(fg)
