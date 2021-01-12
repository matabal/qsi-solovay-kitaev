
# prog = Meta.parse("x^2 - 2y") this will come handy 
const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectengular = (1 + im) / sqrt(2)
expr_to_func(expr::Expr) = @eval (x,y) -> $expr

struct Grid
    equation::Function
    Grid(expr) = new(expr_to_func(expr))
end

# Testin Below
ex = Meta.parse("x^2 - y^2 - 2")
grid = Grid(ex)
println(grid.equation(3, 2))