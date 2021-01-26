module Grids

export Grid1D, GridRectangle, GridAny, getSize, getArea, shiftGrid

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

# To be filled
struct GridAny <:Grid2D 
    #= Any 2D Grid that can be defined as a bounded convex set as shown in 
    Ross & Selinger (2016), pg. 5-6. 
    Note that, a bounded convex set is defined as a function. =#
    equation::Function
end

end # module