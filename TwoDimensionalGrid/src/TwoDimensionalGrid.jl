
# These will come handy: 
# prog = Meta.parse("x^2 - 2y")
# grid = Grid(ex)


module TwoDimensionalGrid

include("Point.jl")
using ..Point: Point1D, Point2D, getPointValue, getBullet, isInGrid

include("Grid.jl")
using ..Grid: Grid1D, GridRectangle, GridAny

include("OneDimensionalGrid.jl")
using ..OneDimensionalGrid: solver1D

const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectengular = (1 + im) / sqrt(2)
expr_to_func(expr::Expr) = @eval (x,y) -> $expr

end # module
