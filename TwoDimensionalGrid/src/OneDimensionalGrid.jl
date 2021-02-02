module OneDimensionalGrid

export solve1D

include("Points.jl")
using ..Points: Point1D, getPointValue, getBullet
include("Grids.jl")
using ..Grids: Grid1D, getSize

const lambda = Point1D(1, 1)
const lambda_inverse = Point1D(-1, 1)

findNextClosestInt(f::Float64) = round(Int, f, RoundUp)
isPointInGrid(point::Point1D, grid::Grid1D) = getPointValue(point) >= grid.lower_bound && getPointValue(point) <= grid.upper_bound ? true : false

# Below is a general scaling operation that scales a 1D grid by a given Point or number.
scaleGrid(grid::Grid1D, scaler::Point1D) = Grid1D(grid.upper_bound*getPointValue(scaler), grid.lower_bound*getPointValue(scaler))
scaleGrid(grid::Grid1D, scaler::Real) = Grid1D(grid.upper_bound*scaler, grid.lower_bound*scaler)

function scaleGrids(A::Grid1D, B::Grid1D)
    #= Performs the scaling of 1D grids as outlined by Ross & Selinger (2016) in pg. 4 
    for solving 1D grid problems. =#
    k = 0 
    while getSize(A) <= 1
        A = scaleGrid(A, lambda_inverse) # Scales A by lambda inverse,
        B = scaleGrid(B, -1*getPointValue(lambda)) # and B by negative lambda.
        k += 1
    end
    return k, Dict([("A", A), ("B", B)])
end

function findIntegersInGrid(grid::Grid1D)
    #= Finds integers in a given 1D grid. =#
    next_int = findNextClosestInt(grid.lower_bound)
    integers = Int[]
    while next_int <= grid.upper_bound
        push!(integers, next_int)
        next_int += 1
    end 
    return integers
end

#= Two functions defined below, namely getIntervalFor_a and getIntervalFor_b, 
correspond to the operations defined by Ross & Selinger (2016), in pg. 4, where
the Proof for Proposition 4.5 is given. =#
getIntervalFor_b(A::Grid1D, B::Grid1D) = Grid1D((A.upper_bound - B.lower_bound)/sqrt(8), (A.lower_bound - B.upper_bound)/sqrt(8))
getIntervalFor_a(A::Grid1D, b::Int) = Grid1D(A.upper_bound - b*sqrt(2), A.lower_bound - b*sqrt(2))

# Checks if an obtained solution is in grid A and its bullet is in grid B.
checkSolution(A::Grid1D, B::Grid1D, solution::Point1D) = isPointInGrid(solution, A) && isPointInGrid(getBullet(solution), B) ? true : false

function enumarateSolutions(A::Grid1D, B::Grid1D, bs::Array)
     #= Enumarates solutions for each coefficient of √2 (i.e. b) found. bs is the 
    array that stores coefficients of √2. See the Proof in Ross & Selinger (2016), pg. 4 =#
    solutions = Point1D[]
    for b in bs
        for a in findIntegersInGrid(getIntervalFor_a(A, b))
            if checkSolution(A, B, Point1D(a, b))
                push!(solutions, Point1D(a, b))
            end
        end
    end
    return solutions
end

#= Below, k is the times the grid A scaled (i.e., grid where the bullets of grid B should reside). 
This function is used for obtaining the rescaling factor that will be used in rescaling the solutions. =#
getRescalingValue(k::Int) = 1/(getPointValue(lambda_inverse)^k)

# Below function rescales a solution obtained for the scaled grids. The rescaling factor is dynamically calculated an is of form 1/√2^k, where k is explained above.
rescaleSolution(point::Point1D, scaling_factor::Int) = getPointValue(point) *getRescalingValue(scaling_factor)

function solve1D(A::Grid1D, B::Grid1D)
    #= Solves 1D grid problem for grids A and B, and returns solutions. Steps of these operation are defined 
    in Ross & Selinger (2016), pg. 4. =#
    k, scaled_grids = scaleGrids(A, B) # Scale grids and save the scaling factor k.
    bs = findIntegersInGrid(getIntervalFor_b(scaled_grids["A"], scaled_grids["B"])) # Find possible values for the coefficient of √2 in scaled grids. 
    scaled_solutions = enumarateSolutions(scaled_grids["A"], scaled_grids["B"], bs) # Solve for scaled (easier) case.
    return [round(rescaleSolution(solution, k), digits=6) for solution in scaled_solutions] # Map the solutions (with rescaleSolution(solution, k) part) back to their original grid. 
end

end # module