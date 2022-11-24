module ROS_Messages

abstract type Msg end
abstract type Std_msgs <: Msg end
abstract type Geometry_msgs <: Msg end
abstract type Sensor_msgs <: Msg end

struct Header <: Std_msgs
    seq::UInt32
    timestamp::UInt64
    frame_id::String
end

function Base.show(io::IO, header::Header)
    print(io, "std_msgs/Header\t")
    print(io, "seq: $(reinterpret(Int32, header.seq))\t")
    print(io, "timestamp: $(header.timestamp)\t")
    print(io, "seq: $(header.frame_id)\t")
end

function Header(data::Vector{UInt8})
    Header(reinterpret(UInt32, data[1:4])..., reinterpret(UInt64, data[5:12])..., String(copy(data[17:end])))
end


struct Vector3 <: Geometry_msgs
    x::Float64
    y::Float64
    z::Float64
end

function Vector3(data::Vector{UInt8})
    Vector3(reinterpret(Float64, data)...)
end

struct Quaternion <: Geometry_msgs
    x::Float64
    y::Float64
    z::Float64
    w::Float64
end

function Quaternion(data::Vector{UInt8})
    Quaternion(reinterpret(Float64, data)...)
end

struct Matrix3 <: Geometry_msgs
    m::Matrix{Float64}
end

function Matrix3(data::Vector{UInt8})
    Matrix3(reshape(reinterpret(Float64, data), (3, 3)))
end

function Base.show(io::IO, ::MIME"text/plain", matrix3::Matrix3)
    println(io, "geometry_msgs/Matrix3")
    print(io, matrix3.m)
end

function Base.show(io::IO, matrix3::Matrix3)
    print(io, "geometry_msgs/Matrix3")
    print(io, matrix3.m)
end

struct Imu <: Sensor_msgs #296bytes + header
    header::Header #variable
    orientation::Quaternion #32bytes
    orientation_cov::Matrix3 #72bytes
    angular_velocity::Vector3 #24bytes
    angular_velocity_cov::Matrix3 #72bytes
    linear_acc::Vector3 #24bytes
    linear_acc_cov::Matrix3 ##72bytes
end

function Imu(data::Vector{UInt8})
    Imu(Header(data[1:(end-296)]), Quaternion(data[(end-295):(end-264)]), Matrix3(data[(end-263):(end-192)]), Vector3(data[(end-191):(end-168)]), Matrix3(data[(end-167):(end-96)]), Vector3(data[(end-95):(end-72)]), Matrix3(data[(end-71):(end)]))
end



function Base.show(io::IO, ::MIME"text/plain", imu::Imu)
    println(io, "sensor_msgs/Imu")
    println(io, "Header:\t $(imu.header)")
    println(io, "Orientation:\t $(imu.orientation)")
    println(io, "Orientation covariance:\t $(imu.orientation_cov)")
    println(io, "Angular Velocity:\t $(imu.angular_velocity)")
    println(io, "Angular Velocity covariance:\t $(imu.angular_velocity_cov)")
    println(io, "Linear acceleration:\t $(imu.linear_acc)")
    println(io, "linear_acc_cov covariance:\t $(imu.linear_acc_cov)")
end

export Header, Vector3, Matrix3, Quaternion, Imu

end
