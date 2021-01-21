module Grids

export Grid1D, GridRectangle, GridAny, getSize, getArea

abstract type Grid end
struct Grid1D <: Grid
    upper_bound::Real
    lower_bound::Real
    Grid1D(x, y) = x > y ? new(x, y) : new(y, x) 
end
getSize(i::Grid1D) = i.upper_bound - i.lower_bound

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