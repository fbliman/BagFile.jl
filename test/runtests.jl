using Test

bagfile = joinpath(ENV["HOME"], "Facultad/Big_files/Bag_Files/inia_bajo_2022-07-06-12-44-02.bag")
bag_info = OpenBag(bagfile)



@test bag_info.path == bagfile
@test (floor(bag_info.duration, Dates.Second)) == Dates.Second(1465)
@test bag_info.messages == 2738777
@test length(bag_info.types) == 11
@test length(bag_info.topics) == 23

iter = Read(bag_info, "/rosout")
next = iterate(iter)
count = 0
while next !== nothing
    (i, state) = next
    count += 1
    next = iterate(iter, state)
end

@test count == 1220