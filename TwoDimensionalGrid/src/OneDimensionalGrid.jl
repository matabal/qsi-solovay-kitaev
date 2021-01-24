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
scaleByLambdaInverse(grid::Grid1D) = Grid1D(grid.upper_bound*getPointValue(lambda_inverse), grid.lower_bound*getPointValue(lambda_inverse))
scaleByLambdaNegative(grid::Grid1D) = Grid1D(grid.upper_bound*getPointValue(lambda)*-1, grid.lower_bound*getPointValue(lambda)*-1)

function scaleGrids(A::Grid1D, B::Grid1D)
    k = 0 
    while getSize(A) >= 1
        A = scaleByLambdaInverse(A)
        B = scaleByLambdaNegative(B)
        k += 1
    end
    return k, Dict([("A", A), ("B", B)])
end

function findIntegersInGrid(grid::Grid1D)
    next_int = findNextClosestInt(grid.lower_bound)
    integers = Int[]
    while next_int <= grid.upper_bound
        push!(integers, next_int)
        next_int += 1
    end 
    return integers
end

getIntervalFor_b(A::Grid1D, B::Grid1D) = Grid1D((A.upper_bound - B.lower_bound)/sqrt(8), (A.lower_bound - B.upper_bound)/sqrt(8))
getIntervalFor_a(A::Grid1D, b::Int) = Grid1D(A.upper_bound - b*sqrt(2), A.lower_bound - b*sqrt(2))

checkSolution(A::Grid1D, B::Grid1D, solution::Point1D) = isPointInGrid(solution, A) && isPointInGrid(getBullet(solution), B) ? true : false

function enumarateSolutions(A::Grid1D, B::Grid1D, bs::Array)
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

getRescalingValue(k::Int) = 1/(getPointValue(lambda_inverse)^k)
rescaleSolution(point::Point1D, scaling_factor::Int) = getPointValue(point) *getRescalingValue(scaling_factor)

function solve1D(A::Grid1D, B::Grid1D)
    k, scaled_grids = scaleGrids(A, B)
    bs = findIntegersInGrid(getIntervalFor_b(scaled_grids["A"], scaled_grids["B"]))
    scaled_solutions = enumarateSolutions(scaled_grids["A"], scaled_grids["B"], bs)
    return [round(rescaleSolution(solution, k), digits=6) for solution in scaled_solutions]
end

end # module