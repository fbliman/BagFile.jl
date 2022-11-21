
using Revise
# Prepare python version
using Pkg



ENV["PYTHON"] = "/usr/bin/python3"
Pkg.build("PyCall")


using PyCall

using RobotOS

@rosimport sensor_msgs.msg:PointCloud2

rostypegen()

using Colors, Caesar


robotslam = SLAMWrapperLocal()


function myHandler(msgdata, slam_::SLAMWrapperLocal)
    # show some header information
    @show "myHandler", msgdata[2].header.seq

    # do stuff
    # addVariable!(slam.dfg, ...)
    # addFactor!(slam.dfg, ...)
    #, etc.

    nothing
end


# find the bagfile
bagfile = joinpath(ENV["HOME"], "Facultad/Big_files/Bag_Files/inia_bajo_2022-07-06-12-44-02.bag")

# open the file
bagSubscriber = RosbagSubscriber(bagfile)

mutable struct MyMsg <: RobotOS.AbstractMsg
    data::Vector{Int8}
    height::Int32
    MyMsg(data, height) = new(data, height)
end

# subscriber callbacks
bagSubscriber("/velodyne_points", PCLPointCloud2, myHandler, (robotslam,))

function Base.convert(::Type{MyMsg}, obj::PyObject)
    msg = MyMsg([], 1)
    print(keys(obj))
    msg.height = obj[:height]
    print(msg.height)
    msg
end

maxloops = 1000
rosloops = 0
while loop!(bagSubscriber)
    # plumbing to limit the number of messages
    rosloops += 1
    if maxloops < rosloops
        @warn "reached --msgloops limit of $rosloops"
        break
    end
    # delay progress for whatever reason
    blockProgress(robotslam) # required to prevent duplicate solves occuring at the same time
end