

include("Points.jl")
using .Points: Point1D, Point2D, getPointValue, getBullet 

include("Grids.jl")
using .Grids: Grid1D, GridRectangle, GridAny

include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: solver1D



function main()

    # Testing Below 
    A = Grid1D(4,6)
    B = Grid1D(-3,3)

    sols = solver1D(A,B)
    println("Solutions: ")
    for s in sols
        println("$(s.a) + $(s.b)√2 = ", getPointValue(s))
    end

end

main()