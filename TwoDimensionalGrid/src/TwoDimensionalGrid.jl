
# These will come handy: 
# prog = Meta.parse("x^2 - 2y")
# grid = Grid(ex)


module TwoDimensionalGrid

include("Points.jl")
using ..Points: Point1D, Point2D, Point2D_StandardForm, Point2D_NormalForm, getPointValue, getBullet, getVectorForm

include("Grids.jl")
using ..Grids: Grid1D, GridRectangle, GridEllipse, shiftGrid, calculateCannonical

include("GridOperators.jl")
using ..GridOperators: GridOperator, getOperatorMatrix

include("OneDimensionalGrid.jl")
using ..OneDimensionalGrid: solve1D

export solve2DRectangles, isInGrid, applyGridOperator
const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectangular = (1 + im) / sqrt(2)
const omega_rectangular_shifter = 1/sqrt(2)
const neg_omega_rectangular_shifter = -1/sqrt(2)


function applyGridOperator(point, operator)
    operator_matrix = getOperatorMatrix(operator)
    vector_form = getVectorForm(point)
    return operator_matrix * vector_form
end


isInGrid(grid::GridEllipse, point::Point2D_NormalForm) = calculateCannonical(grid, getPointValue(point.X_point), getPointValue(point.Y_point)) < 0 ? true : false

function solve2DRectangles(A::GridRectangle, B::GridRectangle)

    solutions1_alpha = solve1D(A.X, B.X)
    solutions1_beta = solve1D(A.Y, B.Y)

    A_shifted = GridRectangle(shiftGrid(A.X, neg_omega_rectangular_shifter), shiftGrid(A.Y, neg_omega_rectangular_shifter))
    B_shifted = GridRectangle(shiftGrid(B.X, omega_rectangular_shifter), shiftGrid(B.Y, omega_rectangular_shifter))

    solutions2_alpha = solve1D(A_shifted.X, B_shifted.X)
    solutions2_beta = solve1D(A_shifted.Y, B_shifted.Y)
    
    println("Expected Solutions: ")
    for sol1 in solutions1_alpha
        for sol2 in solutions1_beta
            println("Solution:  $(sol1) + $(sol2)i")
        end
    end

    println("Problematic Ones: ")
    for sol1 in solutions2_alpha
        for sol2 in solutions2_beta
            println("Solution:  $(sol1) + $(sol2)i")
        end
    end

end

end # module
