module Points

export Point1D, Point2D, getPointValue, getBullet

abstract type Point end

struct Point1D <: Point
    a::Int
    b::Int
end
getPointValue(point::Point1D) = point.a + point.b*sqrt(2)
getBullet(point::Point1D) = Point1D(point.a, -1*point.b)

struct Point2D <: Point
    X_point::Point1D
    Y_point::Point1D
end
getBullet(point::Point2D) = Point2D(getBullet(point.X_point), getBullet(point.Y_point))

end # module