struct Field

    len::UInt32
    name::String
    value::Vector{UInt8}
end

struct Record

    header_len::UInt32
    header::Dict{String,Field}
    data_len::UInt32
    data::Vector{UInt8}

end

struct Msgtype

    type::String
    md5sum::Vector{UInt8}
end

mutable struct Topic

    name::String
    type::Msgtype
    n_msg::Int32
    frec::Float32
    conns::Vector{UInt32}

end

"""
    BagFileData

struct con metadata del BagFile
Para el constructor solo se necesita el path y luego con la funcion open se populan los datos
es posible que se agregue el IO y un puntero de referncia?

"""
mutable struct BagFileData

    path::String
    version::String
    duration::Millisecond
    start_time::DateTime
    end_time::DateTime
    size::Int64
    messages::Int64
    compression::String
    chunks::UInt32
    types::Dict{String,Msgtype}
    topics::Dict{String,Topic}
    connections::Dict{UInt32,String}

end
"""
BagFileData constructor
receives only a String with the path

"""
function BagFileData(path; version="#ROSBAG V2.0", duration=Millisecond(0), start_time=unix2datetime(typemax(Int32)), end_time=unix2datetime(0), size=0, messages=0, compression="none", chunks=0, types=Dict{String,Msgtype}(), topics=Dict{String,Topic}(), connections=Dict{UInt32,String}())

    return BagFileData(path, version, duration, start_time, end_time, size, messages, compression, chunks, types, topics, connections)

end

function Base.show(io::IO, ::MIME"text/plain", bag::BagFileData)
    print(io, "path:\t\t $(bag.path) \n")
    print(io, "version:\t $(bag.version) \n")
    print(io, "duration:\t $(floor(bag.duration, Dates.Minute)):$(floor(mod(bag.duration, Millisecond(60000)), Dates.Second)) ($(floor(bag.duration, Dates.Second)))\n")
    print(io, "start:\t\t $(bag.start_time) \n")
    print(io, "end:\t\t $(bag.end_time) \n")
    if bag.size < 1024^2
        print(io, "size:\t\t $(bag.size/1024)kB \n")
    elseif bag.size < 1024^3
        print(io, "size:\t\t $(bag.size/1024/1024)MB \n")
    elseif bag.size < 1024^4
        print(io, "size:\t\t $(bag.size/1024/1024/1024)GB \n")
    end
    print(io, "messages:\t $(bag.messages) \n")
    print(io, "compression:\t $(bag.compression) [$(bag.chunks)/$(bag.chunks) chunks]\n")
    print(io, "types:")
    for key in sort(collect(keys(bag.types)))
        print(io, "\t\t $key \t\t [$(String(copy(bag.types[key].md5sum)))]\n")
    end
    print(io, "types:")
    for key in sort(collect(keys(bag.topics)))
        print(io, "\t\t $key \t\t $(bag.topics[key].n_msg) msgs\t : $(bag.topics[key].type.type)\n")
    end
end