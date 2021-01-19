include("OneDimensionalGrid.jl")
using .OneDimensionalGrid


function inputToInterval(arg_num::Int) 
    min_max = []
    try
        min_max = split(ARGS[arg_num], ",")
        if length(min_max) > 2
            println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia 1d_gridsolver 2,7 -3,3)")
            return nothing
        end
    catch e
        println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia 1d_gridsolver 2,7 -3,3)")
        return nothing
    end

    min = 0.0
    max = 0.0
    try
        min = parse(Float64, min_max[1])
        max = parse(Float64, min_max[2])
    catch e
        println("Please make sure the intervals entered consists only of real numbers with no space inbetween. (e.g., julia 1d_gridsolver -3,3 4.2,9)")
        return nothing
    end

    if min > max
        println("Please make sure that minimum boundry is always lower than the maximum boundry for both intervals. (e.g., julia 1d_gridsolver 2,7 -3,3)")
        return nothing
    end

    return Interval(max, min)
end

function displayHelp()
    println("\nWelcome to 1 Dimensional Grid Problem Solver! 

To proceed please enter two grids, grid A and grid B, in form:
julia 1d_gridsolver.jl min_A,max_A min_B,max_B \n
Example: julia 1d_gridsolver.jl 4,6 -3,3 
Note that, grid A is where the original points will exist and grid B is where the bullets will exist. \n")
end

function main()

    if length(ARGS) < 1 
        println("\nTo view the help menu, enter:\njulia 1d_gridsolver.jl -h \n")
        exit()
    end

    if ARGS[1] == "--help" || ARGS[1] == "-h" 
        displayHelp()
        exit()
    end
    
    A = inputToInterval(1)
    B = inputToInterval(2)

    if A == nothing || B == nothing
        exit()
    end 

    bs = OneDimensionalGrid.findIntegersInInterval(OneDimensionalGrid.getIntervalFor_b(A, B))
    solutions = OneDimensionalGrid.enumarateSolutions(A, B, bs)

    println("Solutions: ")
    for s in solutions
        println("$(s.a) + $(s.b)√2 = ", getPoint(s))
    end
end

main()