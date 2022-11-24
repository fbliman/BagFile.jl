using Documenter, BagFile


DocMeta.setdocmeta!(BagFile, :DocTestSetup,
    :(using BagFile); recursive=true)

makedocs(
    sitename="BagFile",
    modules=[BagFile],
    format=Documenter.HTML(
        prettyurls=get(ENV, "CI", nothing) == "true",
        assets=["assets/aligned.css"]),
    pages=[
        "Home" => "index.md"
    ],
    doctest=false,
    strict=false
)

deploydocs(
    repo="github.com/fbliman/BagFile.jl.git",
    push_preview=true
)
