module gridrotations
using Plots, ImplicitPlots
Plots.PlotlyBackend()

# prog = Meta.parse("x^2 - 2y") this will come handy. It converts a string to expression
const e = MathConstants.e
const omega =  e^((im*pi)/4)
const omega_rectengular = (1 + im) / sqrt(2)
expr_to_func(expr::Expr) = @eval (x,y) -> $expr

struct Grid
    equation::Function
    Grid(expr) = new(expr_to_func(expr))
end

# Testing Below
f(x,y) = y^2 + x^2 - 2
g(x,y) = 6*(x^2) + 16*x*y + 11*(y^2) - 2

implicit_plot(f, xlims=(-5,5), ylims=(-5,5))
implicit_plot!(g)

while true
    gui()
end


#Plot type: Plots.Plot{Plots.GRBackend}
end # module
