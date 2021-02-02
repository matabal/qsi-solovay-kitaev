module Grids

export Grid1D, GridRectangle, GridEllipse, getSize, getArea, shiftGrid, getBoundingBox

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
shiftGrid(grid::Grid1D, shifter::Real) = Grid1D(grid.upper_bound+shifter, grid.lower_bound+shifter) # Shifts a grid by real number.

abstract type Grid2D <: Grid end
struct GridRectangle <: Grid2D 
    #= 2D Rectangular grid as defined in Ross & Selinger (2016), pg. 5-6. 
    Note that it consists of two 1D grids. =#
    X::Grid1D
    Y::Grid1D
end
getArea(grid::GridRectangle) = getSize(grid.X)*getSize(grid.Y)

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
        println("Please enter the ellipse as defined by the standard equation of an ellipse. i.e., 
        A*(x − h)^2 + B*(x − h)*(y − k) + C*(y − k)^2 - S = 0")
        return nothing
    end
end

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
    x1, x2 = getRoots_X(grid)
    y1, y2 = getRoots_Y(grid)
    return GridRectangle(Grid1D(x1, x2), Grid1D(y1, y2))
end

end # module



#=
function getCoefficient(element::String) 
    coefficient = 1.0
    for sym in split(element, "*")
        if isNumber(String(sym))
            coefficient *= parse(Float64, String(sym))
        end
    end
    return coefficient
end
=#




#=

function equationToElements(equation::String) 
    chars = map(String, split(equation, ""))
    println(chars)
    elements = String[]
    element = ""
    for char in chars
        if char == "+" || char == "-"
            push!(elements, element)
            element = char
        else
            element = string(element, char)
        end
    end
    push!(elements, element)
    elements = map(x->replace(x, " " => "", count = 4), elements)

    return elements
end

function simplifyElement(element::String)
    chars = map(string, split(element, "*"))
    coefficient = 1
    symbolic = ""
    for char in chars
        if isNumber(char)
            coefficient *= eval(Meta.parse(char))
        else
            symbolic = string(symbolic ,char)
        end
    end
    
    is_numerical_power = true
    for char in split(symbolic, "^")
        if !isNumber(string(char)) is_numerical_power = false end 
    end

    if is_numerical_power
        coefficient *= eval(Meta.parse(symbolic))
        return string(coefficient)
    end

    if symbolic == "" return string(coefficient)
    else return string(string(coefficient), "*", symbolic) end
    
end

function splitEquation(equation::String, variable::String ,value::String) 
    exchanged_equation = replace(equation, variable => value)
    elements = equationToElements(exchanged_equation)
    simplified_elements = map(simplifyElement, elements)
    new_equation = ""
    for element in simplified_elements
         new_equation = string(new_equation , element, " + ")
    end
    return chop(new_equation, tail = 2)
 end

exprToFunc(expr::Expr, var1::Symbol) = @eval ($var1) -> $expr
exprToFunc(expr::Expr, var1::Symbol, var2::Symbol) = @eval ($var1, $var2) -> $exprs
isNumber(string::String) = tryparse(Float64, string) !== nothing


=#