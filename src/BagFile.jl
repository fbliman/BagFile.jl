
"""
   BagFile

this module reproduces the "rosbag command-line tool" for Julia
record
Record a bag file with the contents of specified topics.

info IMPLEMENTED 
Summarize the contents of a bag file.

play (not implemented)
Play back the contents of one or more bag files.

check (not implemented)
Determine whether a bag is playable in the current system, or if it can be migrated.

fix (not implemented)
Repair the messages in a bag file so that it can be played in the current system.

filter (not implemented)
Convert a bag file using Python expressions.

compress (not implemented)
Compress one or more bag files.

decompress (not implemented)
Decompress one or more bag files.

reindex (not implemented)
Reindex one or more broken bag files.

.
"""
module BagFile

using Reexport: @reexport

#Dependencies
include("deps.jl")

#ROS Messaje types
include("ROSMessages.jl")
using .ROSMessages

#Exports
include("exports.jl")

#Struct for storing Bagfile MetaData
include("BagFileData.jl")

#Functions for parsing Bag_Files
include("BagReader.jl")

end