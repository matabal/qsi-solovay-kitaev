module OneDimensionalGrid

export getIntervalFor_b, findIntegersInInterval, enumarateSolutions, Point, getPoint, getBullet, Interval, getSize, isInInterval

findNextClosestInt(f::Float64) = round(Int, f, RoundUp)

struct Point
    a::Int
    b::Int
end
getPoint(point::Point) = point.a + point.b*sqrt(2)
getBullet(point::Point) = Point(point.a, -1*point.b)

const lambda = Point(1, 1)
const lambda_inverse = Point(-1, 1)

struct Interval
    upper_bound::Real
    lower_bound::Real
    Interval(x, y) = x > y ? new(x, y) : new(y, x) 
end
getSize(i::Interval) = i.upper_bound - i.lower_bound
scaleByLambdaInverse(i::Interval) = Interval(i.upper_bound*getPoint(lambda_inverse), i.lower_bound*getPoint(lambda_inverse))
scaleByLambdaNegative(i::Interval) = Interval(i.upper_bound*getPoint(lambda)*-1, i.lower_bound*getPoint(lambda)*-1)

isInInterval(point::Point, i::Interval) = getPoint(point) >= i.lower_bound && getPoint(point) <= i.upper_bound ? true : false

function rescaleIntervals(A::Interval, B::Interval)
    while getSize(A) >= 1
        A = scaleByLambdaInverse(A)
        B = scaleByLambdaNegative(B)
    end
    return Dict([("A", A), ("B", B)])
end

function findIntegersInInterval(i::Interval)
    next_int = findNextClosestInt(i.lower_bound)
    integers = Int[]
    while next_int <= i.upper_bound
        push!(integers, next_int)
        next_int += 1
    end 
    return integers
end



getIntervalFor_b(A::Interval, B::Interval) = Interval((A.upper_bound - B.lower_bound)/sqrt(8), (A.lower_bound - B.upper_bound)/sqrt(8))
getIntervalFor_a(A::Interval, b::Int) = Interval(A.upper_bound - b*sqrt(2), A.lower_bound - b*sqrt(2))

function checkSolution(A::Interval, B::Interval, solution::Point)
    if isInInterval(solution, A) && isInInterval(getBullet(solution), B)
        return true
    else
        return false
    end
end

function enumarateSolutions(A::Interval, B::Interval, bs::Array)
    solutions = Point[]
    for b in bs
        for a in findIntegersInInterval(getIntervalFor_a(A, b))
            if checkSolution(A, B, Point(a, b))
                push!(solutions, Point(a, b))
            end
        end
    end
    return solutions
end


end # module
