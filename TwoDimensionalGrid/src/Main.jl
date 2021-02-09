include("Points.jl")
using .Points: Point1D, Point2D, getPointValue, getBullet 

include("Grids.jl")
using .Grids: Grid1D, GridRectangle, GridEllipse, getBoundingBox, getArea, getUprightness

include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: solve1D

include("TwoDimensionalGrid.jl")
using .TwoDimensionalGrid: solve2DRectangles, isInGrid

function main()

    # Testing Bounding Box Function Below
    
    #A*(x − h)^2 + B*(x − h)*(y − k) + C*(y − k)^2 - S = 0
    grid = GridEllipse("3*(x - 0)^2 + 5*(x - 0)*(y - 0) + 3*(y - 0)^2 - 124")
    p1 = Point1D(1, 2)
    p2 = Point1D(-1, 2)
    point_true = Point2D(p1, p2)
    point_false = Point2D(p1, p1)
    println(isInGrid(grid, point_true))
    println(isInGrid(grid, point_false))


    # Testing 2D Rectangle Grids Below
    #A = GridRectangle(Grid1D(1.3,4), Grid1D(0.3,4))
    #B = GridRectangle(Grid1D(-1,1), Grid1D(-1,1))
    #solve2DRectangles(A, B)
    
end

main()