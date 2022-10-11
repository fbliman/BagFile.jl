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
    repo="github.com/fbliman/SLAM_test.jl.git",
    push_preview=true
)
