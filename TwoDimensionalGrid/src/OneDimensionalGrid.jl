module OneDimensionalGrid

export solver1D

include("Points.jl")
using ..Points: Point1D, getPointValue, getBullet
include("Grids.jl")
using ..Grids: Grid1D

isPointInGrid(point::Point1D, grid::Grid1D) = getPointValue(point) >= grid.lower_bound && getPointValue(point) <= grid.upper_bound ? true : false
findNextClosestInt(f::Float64) = round(Int, f, RoundUp)

function findIntegersInGrid(i::Grid1D)
    next_int = findNextClosestInt(i.lower_bound)
    integers = Int[]
    while next_int <= i.upper_bound
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

function solver1D(A::Grid1D, B::Grid1D)
    bs = findIntegersInGrid(getIntervalFor_b(A, B))
    return enumarateSolutions(A, B, bs) 
end

end # module