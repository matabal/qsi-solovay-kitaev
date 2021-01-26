module OneDimensionalGrid

export solve, rescaleSolution, lambda_inverse, scaleIntervals, getIntervalFor_b, findIntegersInInterval, enumarateSolutions, Point, getPoint, getBullet, Interval, getSize, isInInterval

findNextClosestInt(f::Float64) = round(Int, f, RoundUp)

struct Point
    #= Struct to represent a point in Z[√2] ring defined in Ross & Selinger (2016), pg. 3. The integers 
    a and b are used exactly as defined in the paper where a is an integer and b is the coefficient of the √2.=#
    a::Int
    b::Int
end
getPoint(point::Point) = point.a + point.b*sqrt(2) #Returns the real value of a point. (i.e., in added form)
getBullet(point::Point) = Point(point.a, -1*point.b) #The bullet operation as defined in Ross & Selinger (2016), pg. 3.

const lambda = Point(1, 1)
const lambda_inverse = Point(-1, 1)

struct Interval
    #= One dimensional grid as defined in Ross & Selinger (2016), pg. 3-4. 
    Note that, when constructing this struct, the order of the arguments is 
    irrelevant such that larger argument will always be passed to upper_bound 
    and smaller argument will always be passed to lower_bound. =#
    upper_bound::Real
    lower_bound::Real
    Interval(x, y) = x > y ? new(x, y) : new(y, x) 
end
getSize(i::Interval) = i.upper_bound - i.lower_bound

#= Below is a general scaling operation that scales an interval by a given Point or number. =#
scaleInterval(i::Interval, scaler::Point) = Interval(i.upper_bound*getPoint(scaler), i.lower_bound*getPoint(scaler))
scaleInterval(i::Interval, scaler::Real) = Interval(i.upper_bound*scaler, i.lower_bound*scaler)

isInInterval(point::Point, i::Interval) = getPoint(point) >= i.lower_bound && getPoint(point) <= i.upper_bound ? true : false

function scaleIntervals(A::Interval, B::Interval)
    #= This function performs the scaling of 1D grids as outlined by Ross & Selinger (2016) in pg. 4 
    for solving 1D grid problems. =#
    k = 0 
    while getSize(A) >= 1
        A = scaleInterval(A, lambda_inverse) # Scales A by lambda inverse,
        B = scaleInterval(B, -1*getPoint(lambda)) # and B by negative lambda.
        k += 1
    end
    return k, Dict([("A", A), ("B", B)])
end

# Below, k is the times the interval A scaled. This function is used for obtaining the rescaling factor that will be used in rescaling the solutions.
getRescalingValue(k::Int) = 1/(getPoint(lambda_inverse)^k) 

# Below function rescales a solution obtained for the scaled grids. The rescaling factor is dynamically calculated an is of form 1/√2^k, where k is explained above.
rescaleSolution(point::Point, scaling_factor::Int) = getPoint(point) *getRescalingValue(scaling_factor) 

function findIntegersInInterval(i::Interval)
    #= Finds integers in a given interval. =#
    next_int = findNextClosestInt(i.lower_bound)
    integers = Int[]
    while next_int <= i.upper_bound
        push!(integers, next_int)
        next_int += 1
    end 
    return integers
end

#= Two functions defined below, namely getIntervalFor_a and getIntervalFor_b, 
corresponds to the operations defined by Ross & Selinger (2016), in pg. 4. where
the Proof for Proposition 4.5 is given. =#
getIntervalFor_b(A::Interval, B::Interval) = Interval((A.upper_bound - B.lower_bound)/sqrt(8), (A.lower_bound - B.upper_bound)/sqrt(8))
getIntervalFor_a(A::Interval, b::Int) = Interval(A.upper_bound - b*sqrt(2), A.lower_bound - b*sqrt(2))

# Checks if an obtained solution is in Interval A and its bullet is in Interval B.
checkSolution(A::Interval, B::Interval, solution::Point) = isInInterval(solution, A) && isInInterval(getBullet(solution), B) ? true : false 

function enumarateSolutions(A::Interval, B::Interval, bs::Array)
    #= Enumarates solutions for each coefficient of √2 (i.e. b) found. bs is the 
    array that stores coefficients of √2. See the Proof in Ross & Selinger (2016), pg. 4 =#
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

function solve(A::Interval, B::Interval)
    #= Solves 1D grid problem for grids A and B, and returns solutions (also k and scaled solutions for cosmetic 
    purposes in Main.jl). Steps of these operation are defined in Ross & Selinger (2016), pg. 4. =#
    k, scaled_intervals = scaleIntervals(A, B) #Scale intervals and save the scaling factor k.
    bs = findIntegersInInterval(getIntervalFor_b(scaled_intervals["A"], scaled_intervals["B"])) # Find possible values for the coefficient of √2 in scaled intervals. 
    scaled_solutions = enumarateSolutions(scaled_intervals["A"], scaled_intervals["B"], bs) # Solve for scaled (easier) case.
    return k, scaled_solutions, [rescaleSolution(solution, k) for solution in scaled_solutions] # Map the solutions (with rescaleSolution(solution, k) part) back to their original grid. 
end

end # module
