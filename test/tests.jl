


######### testes ####################

Bagpath = joinpath(ENV["HOME"], "Facultad/Big_files/Bag_Files/inia_bajo_2022-07-06-12-44-02.bag")

Bagpath2 = joinpath(ENV["HOME"], "Facultad/Big_files/Bag_Files/inia_alto_2022-07-06-11-45-29.bag")


data = read_all(Bagpath)



bag_info = OpenBag(Bagpath)



records = read_all(Bagpath)
records[1]


next = iterate(Read(bag_info, "/imu/data"))
(i, state) = next
next = iterate(Read(bag_info, "/imu/data"), next[2])
(i, state) = next
next[2].chunk_num
String(copy(next[1].data))
next[1].header

next[1].data[1:4]
next[1].data[5:12]
reinterpret(Int32, next[1].data[13:16])
String(copy(next[1].data[17:24]))
orientation = reinterpret(Float64, next[1].data[25:(24+8*4)])
orientation_cov = reshape(reinterpret(Float64, next[1].data[(25+8*4):(24+8*13)]), (3, 3))
angular_vel = reinterpret(Float64, next[1].data[(25+8*13):(24+8*16)])
angular_cov = reshape(reinterpret(Float64, next[1].data[(25+8*16):(24+8*25)]), (3, 3))
linear_vel = reinterpret(Float64, next[1].data[(25+8*25):(24+8*28)])
lienar_cov = reshape(reinterpret(Float64, next[1].data[(25+8*28):(24+8*37)]), (3, 3))
unix2datetime(copy(reinterpret(Int32, next[1].data[5:8]))[1])
24 + 8 * 37

a = Imu(next[1].data)
BagFile
io = open("ros_output.txt", "w")
write(io, run(`rosbag info $BagFile`))
close(io)
io = open("ros_output.txt", "r")
read(io, String)
typeof(ros_output)
ros_output.cmd


io = IOBuffer()
show(IOContext(io), "text/plain", run(`rosbag info $BagFile`))
s = String(take!(io))
print(s)