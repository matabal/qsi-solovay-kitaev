include("Points.jl")
using .Points: Point1D, Point2D, getPointValue, getBullet 

include("Grids.jl")
using .Grids: Grid1D, GridRectangle, GridEllipse, getBoundingBox

include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: solve1D

include("TwoDimensionalGrid.jl")
using .TwoDimensionalGrid: solve2DRectangles

function main()

    # Testing Bounding Box Function Below
    grid = GridEllipse("5*(x - 2)^2 + 2*(x - 2)*(y - 3) + 3*(y - 3)^2 - 2")
    println(getBoundingBox(grid))

    # Testing 2D Rectangle Grids Below
    #A = GridRectangle(Grid1D(1.3,4), Grid1D(0.3,4))
    #B = GridRectangle(Grid1D(-1,1), Grid1D(-1,1))
    #solve2DRectangles(A, B)
    
end

main()