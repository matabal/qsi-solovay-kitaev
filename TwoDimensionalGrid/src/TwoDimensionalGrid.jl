
module TwoDimensionalGrid

# These will come handy: 
# prog = Meta.parse("x^2 - 2y")
# grid = Grid(ex)

const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectengular = (1 + im) / sqrt(2)
expr_to_func(expr::Expr) = @eval (x,y) -> $expr

struct Grid
    equation::Function
    Grid(expr) = new(expr_to_func(expr))
end
#findEnclosingEllipse(grid::Grid) = Grid()

end # module
