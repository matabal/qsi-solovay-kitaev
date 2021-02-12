module Grids

export Grid1D, GridRectangle, GridEllipse, getSize, getArea, shiftGrid, getBoundingBox, getUprightness, calculateCannonical

abstract type Grid end 

struct Grid1D <: Grid
    #= One dimensional grid as defined in Ross & Selinger (2016), pg. 3-4. 
    Note that, when constructing this struct, the order of the arguments is 
    irrelevant such that larger argument will always be passed to upper_bound 
    and smaller argument will always be passed to lower_bound. =#
    upper_bound::Real
    lower_bound::Real
    Grid1D(x, y) = x > y ? new(x, y) : new(y, x) 
end
getSize(grid::Grid1D) = grid.upper_bound - grid.lower_bound
canGridExist(grid::Grid1D) = getSize(grid) > 0 ? true : false # Checks if a given grid can exist.
shiftGrid(grid::Grid1D, shifter::Real) = Grid1D(grid.upper_bound+shifter, grid.lower_bound+shifter) # Shifts a grid by real number.

abstract type Grid2D <: Grid end
struct GridRectangle <: Grid2D 
    #= 2D Rectangular grid as defined in Ross & Selinger (2016), pg. 5-6. 
    Note that it consists of two 1D grids. =#
    X::Grid1D
    Y::Grid1D
end
getArea(grid::GridRectangle) = getSize(grid.X)*getSize(grid.Y)
canGridExist(grid::GridRectangle) = canGridExist(grid.X) && canGridExist(grid.Y) ? true : false
# 2D Grids Below

struct GridEllipse <:Grid2D 
    #= Ellipse 2D Grid. The variables defined below correspond to the standard equation ellipse below:
    A*(x − h)^2 + B*(x − h)*(y − k) + C*(y − k)^2 - S = 0
    =#
    A::Real
    B::Real
    C::Real
    S::Real
    h::Real
    k::Real
    function GridEllipse(equation::String)
        A, B, C, S, h, k = destructEllipseExpression(equation)
        new(A, B, C, S, h, k)
    end
end
getArea(grid::GridEllipse) = grid.S*((2*pi)/(sqrt(4*grid.A*grid.C - (grid.B)^2)))
calculateCannonical(grid::GridEllipse, x::Real, y::Real) = grid.A*((x - grid.h)^2) + grid.B*(x - grid.h)*(y - grid.k) + grid.C*((y - grid.k)^2) - grid.S

function destructEllipseExpression(equation::String)
    expr = Meta.parse(equation)
    A = B = C = S = h = k = 0
    try
        S = last(expr.args) 
        for exp in expr.args[2].args
            if exp isa Expr && :^ in exp.args[3].args
                if :x in exp.args[3].args[2].args
                    A = exp.args[2]
                    h = exp.args[3].args[2].args[3]
                end
                if :y in exp.args[3].args[2].args
                    C = exp.args[2]
                    k = exp.args[3].args[2].args[3]
                end
            elseif exp isa Expr
                B = exp.args[2]
            end
        end
        return A, B, C, S, h, k
    catch e
        return 0, 0, 0, 0, 0, 0 #If given ellipse equation is mistaken, sets every value to 0.
    end
end


#= 
The functions below, namely getQuadraticCoefficient_Y, getQuadraticCoefficient_X, 
getQuadraticFunction_Y, getQuadraticFunction_X, getRoots_Y, getRoots_X, getBoundingBox
are mathematical operationgs defined for calculating the bounding box of an ellipse grid.
These operations are defined based on information from link, 
https://math.stackexchange.com/questions/922806/how-to-find-the-outermost-points-in-an-ellipse
where the user Mark Bennet explained the method for finding the outermost points of an ellipse. 

Note that, they will only work with the standard equation of an ellipse given as an input, i.e., 
A*(x − h)^2 + B*(x − h)*(y − k) + C*(y − k)^2 - S = 0
given without the "= 0" part at the end.

If these operations need to be extended for non-quadratic cases, following libraries can be useful:
    https://github.com/JuliaMath/Roots.jl                       --> For finding the roots of any function.
    https://github.com/JuliaIntervals/IntervalRootFinding.jl/   --> For finding the roots of any function.
    https://github.com/JuliaStaging/GeneralizedGenerated.jl     --> For converting regular expressions in subroutines without the "World Age" problem.
    https://github.com/JuliaMath/Calculus.jl                    --> For calculating derivatives. Symbolic or numeric.
=#

getQuadraticCoefficient_Y(grid::GridEllipse) = (((grid.B)^2)/(4*grid.A)) - (((grid.B)^2)/(2*grid.A)) + grid.C
getQuadraticCoefficient_X(grid::GridEllipse) = (((grid.B)^2)/(4*grid.C)) - (((grid.B)^2)/(2*grid.C)) + grid.A

function getQuadraticFunction_Y(grid::GridEllipse)
    coefficient = getQuadraticCoefficient_Y(grid)
    a = coefficient
    b = -2*(grid.k)*coefficient
    c = (coefficient*(grid.k)^2) - grid.S 
    return Dict("a" => a, "b" => b, "c" => c)
end

function getQuadraticFunction_X(grid::GridEllipse)
    coefficient = getQuadraticCoefficient_X(grid)
    a = coefficient
    b = -2*(grid.h)*coefficient
    c = (coefficient*(grid.h)^2) - grid.S 
    return Dict("a" => a, "b" => b, "c" => c)
end

function getRoots_Y(grid::GridEllipse)
    func = getQuadraticFunction_Y(grid)
    y1 = (-1*func["b"] + sqrt(((func["b"])^2) - 4*func["a"]*func["c"]))/(2*func["a"])
    y2 = (-1*func["b"] - sqrt(((func["b"])^2) - 4*func["a"]*func["c"]))/(2*func["a"])
    return y1, y2
end

function getRoots_X(grid::GridEllipse)
    func = getQuadraticFunction_X(grid)
    x1 = (-1*func["b"] + sqrt(((func["b"])^2) - 4*func["a"]*func["c"]))/(2*func["a"])
    x2 = (-1*func["b"] - sqrt(((func["b"])^2) - 4*func["a"]*func["c"]))/(2*func["a"])
    return x1, x2
end

function getBoundingBox(grid::GridEllipse)
    x1 = x2 = y1 = y2 = 0 
    try
        x1, x2 = getRoots_X(grid)
        y1, y2 = getRoots_Y(grid)
    catch e
        if isa(e, DomainError)
            x1 = x2 = y1 = y2 = -1 #If entered equation is not a ellipse (i.e., if discriminant < 0), returns a GridRectangle with this values
        else
            println(e)
        end
    end
    return GridRectangle(Grid1D(x1, x2), Grid1D(y1, y2))
end

function canGridExist(grid::GridEllipse)
    if grid.A + grid.B + grid.C + grid.S + grid.h + grid.k == 0
        return false
    end
    
    boundingBox = getBoundingBox(grid)
    if !canGridExist(grid)
        return false
    end
    return true
end

getUprightness(grid::GridEllipse) = getArea(grid) / getArea(getBoundingBox(grid))


end # module

