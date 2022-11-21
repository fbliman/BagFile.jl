
using Revise
# Prepare python version
using Pkg



ENV["PYTHON"] = "/usr/bin/python3"
Pkg.build("PyCall")


using PyCall

using RobotOS

@rosimport sensor_msgs.msg:PointCloud2
@rosimport std_msgs.msg:String

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



bagrd = Caesar.RosbagParser(bagfile, "/velodyne_points")
msg = bagrd.get_next_message

print(keys(msg))
typeof(msg)
eltype(msg)
print(msg[:__getattribute__])


while msg[0] != false
    print(msg[1])
    msg = bagrd.get_next_mes
end

