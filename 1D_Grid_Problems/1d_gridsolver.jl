#getFloatingPoints(f::Float64) = parse(Float64, "0.$(split(string(f), ".")[2])") #Using modulo 1 insteead of this gives floating points error!
#findNextClosestInt(f::Float64) = convert(Int, f >= 0 ? 1 - getFloatingPoints(f) + f : getFloatingPoints(f) + f)

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

function inputToInterval(arg_num::Int) 
    min_max = []
    try
        min_max = split(ARGS[arg_num], ",")
        if length(min_max) > 2
            println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia 1d_gridsolver 2,7 -3,3)")
            return nothing
        end
    catch e
        println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia 1d_gridsolver 2,7 -3,3)")
        return nothing
    end

    min = 0.0
    max = 0.0
    try
        min = parse(Float64, min_max[1])
        max = parse(Float64, min_max[2])
    catch e
        println("Please make sure the intervals entered consists only of real numbers with no space inbetween. (e.g., julia 1d_gridsolver -3,3 4.2,9)")
        return nothing
    end

    if min > max
        println("Please make sure that minimum boundry is always lower than the maximum boundry for both intervals. (e.g., julia 1d_gridsolver 2,7 -3,3)")
        return nothing
    end

    return Interval(max, min)
end

function displayHelp()
    println("\nWelcome to 1 Dimensional Grid Problem Solver! 

To proceed please enter two grids, grid A and grid B, in form:
julia 1d_gridsolver.jl min_A,max_A min_B,max_B \n
Example: julia 1d_gridsolver.jl 4,6 -3,3 
Note that, grid A is where the original points will exist and grid B is where the bullets will exist. \n")
end


function main()

    if length(ARGS) < 1 
        println("\nTo view the help menu, enter:\njulia 1d_gridsolver.jl -h \n")
        exit()
    end

    if ARGS[1] == "--help" || ARGS[1] == "-h" 
        displayHelp()
        exit()
    end
    
    A = inputToInterval(1)
    B = inputToInterval(2)

    if A == nothing || B == nothing
        exit()
    end 

    bs = findIntegersInInterval(getIntervalFor_b(A, B))
    solutions = enumarateSolutions(A, B, bs)

    println("Solutions: ")
    for s in solutions
        println("$(s.a) + $(s.b)√2 = ", getPoint(s))
    end
end

main()