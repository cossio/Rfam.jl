import Documenter
import Literate
import Rfam

# Run Literate.jl over the tutorial sources, generating Markdown files next to
# them. The generated `.md` files are git-ignored (see `.gitignore`).
const literate_dir = joinpath(@__DIR__, "src", "literate")
for file in readdir(literate_dir; join = true)
    if endswith(file, ".jl")
        Literate.markdown(file, literate_dir; documenter = true)
    end
end

Documenter.makedocs(
    modules = [Rfam],
    sitename = "Rfam.jl",
    authors = "Jorge Fernandez-de-Cossio-Diaz",
    repo = Documenter.Remotes.GitHub("cossio", "Rfam.jl"),
    pages = [
        "Home" => "index.md",
        "Tutorial" => "literate/tutorial.md",
        "Reference" => "reference.md",
    ],
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://cossio.github.io/Rfam.jl/stable/",
    ),
)

Documenter.deploydocs(
    repo = "github.com/cossio/Rfam.jl.git",
    devbranch = "master",
    push_preview = true,
)
