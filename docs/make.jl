using Documenter, DocumenterCitations
using FerriteAMR

DocMeta.setdocmeta!(FerriteAMR, :DocTestSetup, :(using FerriteAMR); recursive=true)

bibtex_plugin = CitationBibliography(
    joinpath(@__DIR__, "src", "assets", "references.bib"),
    style=:numeric
)

makedocs(;
    modules=[FerriteAMR],
    authors="Pei-Liang Bian",
    sitename="FerriteAMR.jl",
    format=Documenter.HTML(;
        canonical="https://bplcn.github.io/FerriteAMR.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",        
        "API" => "AMR.md",
        "References" => "references.md",
    ],
    plugins = [
        bibtex_plugin,
    ]
)

deploydocs(;
    repo="github.com/bplcn/FerriteAMR.jl",
    devbranch="master",
)
