module Grids

export Grid1D, GridRectangle, GridAny, getSize, getArea, shiftGrid

abstract type Grid end
struct Grid1D <: Grid
    upper_bound::Real
    lower_bound::Real
    Grid1D(x, y) = x > y ? new(x, y) : new(y, x) 
end
getSize(grid::Grid1D) = grid.upper_bound - grid.lower_bound
shiftGrid(grid::Grid1D, shifter::Real) = Grid1D(grid.upper_bound+shifter, grid.lower_bound+shifter) 

abstract type Grid2D <: Grid end
struct GridRectangle <: Grid2D 
    X::Grid1D
    Y::Grid1D
end
getArea(grid::GridRectangle) = getSize(grid.X)*getSize(grid.Y)

# To be filled
struct GridAny <:Grid2D 
    equation::Function
end

end # module