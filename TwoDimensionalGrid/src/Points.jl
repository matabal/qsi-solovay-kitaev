module Points

export Point1D, Point2D, Point2D_NormalForm, getPointValue, getBullet, getVectorForm

abstract type Point end

struct Point1D <: Point
    #= Represents 1D point in Z[√2] ring as defined in Ross & Selinger (2016), pg. 3. The integers 
    a and b are used exactly as defined in the paper where a is an integer and b is the coefficient of √2.=#
    a::Int
    b::Int
end
getPointValue(point::Point1D) = point.a + point.b*sqrt(2) #Returns the real value of a point. (i.e., in added form)
getBullet(point::Point1D) = Point1D(point.a, -1*point.b) #The bullet operation as defined in Ross & Selinger (2016), pg. 3.

const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectangular = (1 + im) / sqrt(2)

abstract type Point2D end

struct Point2D_StandardForm <: Point
    a::Int
    b::Int
    c::Int
    d::Int
end
getBullet(point::Point2D_StandardForm) = Point2D_StandardForm(-1*point.a, point.b, -1*point.c, point.d)
getPointValue(point::Point2D_StandardForm) = point.a*(omega_rectangular)^3 + point.b*(omega_rectangular)^2 + point.c*(omega_rectangular) + point.d


struct Point2D_NormalForm <: Point2D
#= 2D Point in ring D[√2] (and Z[omega]) as defined in Ross & Selinger (2016), pg. 3. 
Note that, this representation that divides the 2D point into two 1D points relies on 
the definition of a point (denoted by letter u) given in pg. 5 of Ross & Selinger (2016). =#
    X_point::Point1D
    Y_point::Point1D
    Point2D_NormalForm(point::Point2D_StandardForm) = (point.c - point.a) % 2 == 0 ? new(Point1D(point.d, (point.c - point.a)/2), Point1D(point.b, (point.c + point.a)/2)) : new(Point1D(point.d, (point.c - point.a - 1)/2), Point1D(point.b, (point.c + point.a - 1)/2))
    Point2D_NormalForm(x_point::Point1D, y_point::Point1D) = new(x_point, y_point)
end
getBullet(point::Point2D_NormalForm) = Point2D_NormalForm(getBullet(point.X_point), getBullet(point.Y_point))
getPointValue(point::Point2D_NormalForm) = getPointValue(point.X_point) + getPointValue(point.Y_point)*im
getVectorForm(point::Point2D_NormalForm) = [getPointValue(point.X_point) ; getPointValue(point.Y_point)]

function getVectorForm(point::Point2D_StandardForm)
    normal_form = Point2D_NormalForm(point)
    println(normal_form)
    return getVectorForm(normal_form)
end

end # module