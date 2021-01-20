# Testing Below 

include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: Point, Interval

include("RectangularGrid.jl")
using .RectangularGrid: RectangleGrid, Point2D, getArea, getBullet2D

p = Point2D(Point(2,3), Point(1,4))
b = getBullet2D(p)
println("Point: ", p)
println("Bullet: ", b)