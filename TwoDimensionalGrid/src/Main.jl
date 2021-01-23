include("Points.jl")
using .Points: Point1D, Point2D, getPointValue, getBullet 

include("Grids.jl")
using .Grids: Grid1D, GridRectangle, GridAny

include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: solve1D

include("TwoDimensionalGrid.jl")
using .TwoDimensionalGrid: solve2DRectangles



function main()

    # Testing 2D Rectangle Grids Below

    A = GridRectangle(Grid1D(1.3,4), Grid1D(0.3,4))
    B = GridRectangle(Grid1D(-1,1), Grid1D(-1,1))
    solve2DRectangles(A, B)
    
    #

    

    #= Testing 1D Grids Below

    A = Grid1D(-8,-4)
    B = Grid1D(-3,3)

    sols = solve1D(A,B)
    println("Solutions: ")
    for s in sols
        println("$(s.a) + $(s.b)√2 = ", getPointValue(s))
    end
    
    =#
end

main()