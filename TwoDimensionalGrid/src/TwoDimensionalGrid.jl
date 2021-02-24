
# These will come handy: 
# prog = Meta.parse("x^2 - 2y")
# grid = Grid(ex)


module TwoDimensionalGrid

include("Points.jl")
using ..Points: Point1D, Point2D, Point2D_StandardForm, Point2D_NormalForm, Point2D_SimpleForm, getPointValue, getBullet, getVectorForm

include("Grids.jl")
using ..Grids: Grid1D, GridRectangle, GridEllipse, shiftGrid, calculateCannonical, getBoundingBox, getUprightness

include("GridOperators.jl")
using ..GridOperators: GridOperator, getOperatorMatrix

include("OneDimensionalGrid.jl")
using ..OneDimensionalGrid: solve1D

export solve2DRectangles, isInGrid, applyGridOperator, solve2DEllipses
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
isInGrid(grid::GridEllipse, point::Point2D_SimpleForm) = calculateCannonical(grid, point.alpha, point.beta) < 0 ? true : false



function solve2DEllipses(A::GridEllipse, B::GridEllipse)

    #= Below grid operation functions will be defined. 
    
    while getUprightness(A) > X     -> X will definded 
        A = rotate(A)
        B = rotate(B)
    end
    =#

    boundingBox_A = getBoundingBox(A)
    boundingBox_B = getBoundingBox(B)
    solutions_rectangle = solve2DRectangles(boundingBox_A, boundingBox_B)
    solutions_ellipse = []
    for solution in solutions_rectangle
        if !isInGrid(A, solution)
            push!(solutions_ellipse, solution)
        end
    end

    return solutions_ellipse
end


function solve2DRectangles(A::GridRectangle, B::GridRectangle)

    solutions1_alpha = solve1D(A.X, B.X)
    solutions1_beta = solve1D(A.Y, B.Y)

    A_shifted = GridRectangle(shiftGrid(A.X, neg_omega_rectangular_shifter), shiftGrid(A.Y, neg_omega_rectangular_shifter))
    B_shifted = GridRectangle(shiftGrid(B.X, omega_rectangular_shifter), shiftGrid(B.Y, omega_rectangular_shifter))

    solutions2_alpha = solve1D(A_shifted.X, B_shifted.X)
    solutions2_beta = solve1D(A_shifted.Y, B_shifted.Y)
    
    solutions2_alpha = [x + omega_rectangular_shifter for x in solutions2_alpha]
    solutions2_beta = [x + omega_rectangular_shifter for x in solutions2_beta]

    solutions = Point2D_SimpleForm[]
    for alpha in solutions1_alpha
        for beta in solutions1_beta
            push!(solutions, Point2D_SimpleForm(alpha, beta))
        end
    end

    for alpha in solutions2_alpha
        for beta in solutions2_beta
            push!(solutions, Point2D_SimpleForm(alpha, beta))
        end
    end

    return solutions

end

end # module
