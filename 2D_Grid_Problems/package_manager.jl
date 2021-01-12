import Pkg

PACKAGES = [
    
]

for pkg in PACKAGES
    if !(pkg ∈ keys(Pkg.installed()))
        Pkg.add(pkg)
    end
end

