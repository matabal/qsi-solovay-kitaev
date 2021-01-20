module RectangularGrid

include("OneDimensionalGrid.jl")
using ..OneDimensionalGrid: Point, getBullet, getSize, Interval

export RectangleGrid, Point2D, getBullet2D

struct Point2D
    X_point::Point
    Y_point::Point
end
getBullet2D(point::Point2D) = Point2D(getBullet(point.X_point), getBullet(point.Y_point))

struct RectangleGrid
    X::Interval
    Y::Interval
end
getArea(grid::RectangleGrid) = getSize(grid.X)*getSize(grid.Y)


end # module