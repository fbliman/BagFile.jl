using Documenter, SLAM_test


DocMeta.setdocmeta!(SLAM_test, :DocTestSetup,
    :(using SLAM_test); recursive=true)

makedocs(
    sitename="SLAM_test",
    modules=[SLAM_test],
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true",
        assets=["assets/aligned.css"]),
    pages=[
        "Home" => "index.md"
    ],
    strict=true
)

deploydocs(
<<<<<<< HEAD
<<<<<<< HEAD
    repo="github.com/fbliman SLAM_test.jl.git",
=======
    repo="github.com/fbliman/SLAM_test.jl.git",
>>>>>>> 848f044613b5a25ad120e8bdc7d689a675f03cdb
=======
    repo="github.com/fbliman/SLAM_test.jl.git",
>>>>>>> 848f044613b5a25ad120e8bdc7d689a675f03cdb
    push_preview=true
)
