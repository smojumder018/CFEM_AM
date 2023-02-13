using CFEM_AM
using Documenter

DocMeta.setdocmeta!(CFEM_AM, :DocTestSetup, :(using CFEM_AM); recursive=true)

makedocs(;
    modules=[CFEM_AM],
    authors="Acme Corp",
    repo="https://github.com/Satyajit/CFEM_AM.jl/blob/{commit}{path}#{line}",
    sitename="CFEM_AM.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Satyajit.github.io/CFEM_AM.jl",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Satyajit/CFEM_AM.jl",
    devbranch="master",
)
