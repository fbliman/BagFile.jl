
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
bagfile = joinpath(ENV["HOME"], "fede/Facultad/Big_files/Bag_Files/inia_bajo_2022-07-06-12-44-02.bag")

# open the file
bagSubscriber = RosbagSubscriber(bagfile)

struct MyMsg <: RobotOS.AbstractMsg
    m::String
    MyMsg(m) = new(m)
end

# subscriber callbacks
bagSubscriber("/velodyne_points", MyMsg(""), myHandler, (robotslam,))


isa(MyMsg(""), RobotOS.AbstractMsg)