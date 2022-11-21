using Revise
using Dates

# find the bagfile
bagfile = joinpath(ENV["HOME"], "Facultad/Big_files/Bag_Files/inia_bajo_2022-07-06-12-44-02.bag")
#bag = open(bagfile)


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
    n_msg::UInt32
    frec::Float32
    conns::Vector{UInt32}

end


mutable struct Bagfile

    path::String
    version::String
    duration::Float32
    start_time::DateTime
    end_time::DateTime
    size::Int64
    messages::Int64
    compression::String
    chunks::Int32
    types::Dict{String,Msgtype}
    topics::Dict{String,Topic}

    Bagfile(file) = new(file)
end

Bagfile(bagfile)

"""
Funcion para leer la primera linea del rosbag y verificar que esta OK

"""
function leer_header(io::IO)

    h = readline(io)
    println(h)
    expected = "#ROSBAG V2.0"
    if h == expected
        return true
    else
        return false
    end
end

function leer_record(io::IO)
    header_len = read(io, UInt32)
    #println("el lenght del header es $header_len")
    header_hex = Vector{UInt8}(undef, header_len)
    readbytes!(io, header_hex)
    #ahora tengo que leer los fields
    header = Dict{String,Field}()
    counter = 1
    while counter < header_len
        field_len = copy(reinterpret(UInt32, header_hex[counter:(counter+3)]))[1]
        #println("length de field = $field_len")
        counter = counter + 4
        field_name_value = header_hex[counter:(counter+field_len-1)]
        counter = counter + field_len
        separator = findfirst(==(0x3d), field_name_value)
        field_name = String(field_name_value[1:(separator-1)])
        field_value = field_name_value[(separator+1):end]
        field = Field(field_len, field_name, field_value)
        header[field_name] = field
        #println("Field = $field")
    end

    data_len = read(io, UInt32)
    #println("el lenght del data es $data_len")
    data_hex = Vector{UInt8}(undef, data_len)
    readbytes!(io, data_hex)

    return Record(header_len, header, data_len, data_hex)

end



"""
Funcion que recibe un bag y devuelve lista (o dict) con los topics
"""

function topics(bag::IO)

    topics = Dict{String,Topic}() #dictionary tu return
    leer_header(bag)
    record = leer_record(bag)
    while record.header["op"].value != UInt8[0x07]  #busco topic indormation
        record = leer_record(bag)
    end


    while record.header["op"].value == UInt8[0x07]  #proceso connections 
        if !haskey(topics, String(copy(record.header["topic"].value)))
            topics[String(copy(record.header["topic"].value))] = Topic(String(copy(record.header["topic"].value)), "", [], 0, 0.0, copy(reinterpret(UInt32, record.header["conn"].value)))

        end
        #println(String(copy(record.header["topic"].value)))
        record = leer_record(bag)

    end

    return topics


end


"""
Funcion que inicialize un bagfile y devuelve el struct bagfile con la metadata
"""

function OpenBag(path::String)
    file = open(path)  #abro archivo
    bag = Bagfile(path)   #creo Bagfile
    if leer_header(file)
        bag.version = "2.0"
    else
        error("Bagfile before 2.0 not compatible")
    end



end


bag = open(bagfile)

topicos = topics(bag)




f = leer_header(bag)
record = leer_record(bag)

record
String(record.header["compression"].value)
record.header["op"].value


while record.header["op"].value == UInt8[0x04] || record.header["op"].value == UInt8[0x05]
    record = leer_record(bag)
end

while record.header["op"].value == UInt8[0x06]
    record = leer_record(bag)
end

a = [3,]

copy(reinterpret(UInt32, record.header["conn"].value))
unix2datetime(88484848)
typeof(filesize(bagfile))