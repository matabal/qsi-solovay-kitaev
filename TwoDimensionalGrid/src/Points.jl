module Points

export Point1D, Point2D, getPointValue, getBullet

abstract type Point end

struct Point1D <: Point
    #= Represents 1D point in Z[√2] ring as defined in Ross & Selinger (2016), pg. 3. The integers 
    a and b are used exactly as defined in the paper where a is an integer and b is the coefficient of √2.=#
    a::Int
    b::Int
end
getPointValue(point::Point1D) = point.a + point.b*sqrt(2) #Returns the real value of a point. (i.e., in added form)
getBullet(point::Point1D) = Point1D(point.a, -1*point.b) #The bullet operation as defined in Ross & Selinger (2016), pg. 3.

struct Point2D <: Point
    #= 2D Point in ring D[√2] (and Z[omega]) as defined in Ross & Selinger (2016), pg. 3. 
    Note that, this representation that divides the 2D point into two 1D points relies on 
    the definition of a point (denoted by letter u) given in pg. 5 of Ross & Selinger (2016). =#
    X_point::Point1D
    Y_point::Point1D
end
getBullet(point::Point2D) = Point2D(getBullet(point.X_point), getBullet(point.Y_point))

end # module