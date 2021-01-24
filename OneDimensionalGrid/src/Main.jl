include("OneDimensionalGrid.jl")
using .OneDimensionalGrid: Point, Interval, solve


function inputToInterval(arg_num::Int) 
    min_max = []
    try
        min_max = split(ARGS[arg_num], ",")
        if length(min_max) > 2
            println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia --project src/Main.jl 4,6 -3,3)")
            return nothing
        end
    catch e
        println("Please enter intervals in form min_A,max_A min_B,max_B. (e.g., julia --project src/Main.jl 4,6 -3,3)")
        return nothing
    end

    min = 0.0
    max = 0.0
    try
        min = parse(Float64, min_max[1])
        max = parse(Float64, min_max[2])
    catch e
        println("Please make sure the intervals entered consists only of real numbers with no space inbetween. (e.g., julia --project src/Main.jl 4,6 -3.4,3)")
        return nothing
    end

    if min > max
        println("Please make sure that minimum boundry is always lower than the maximum boundry for both intervals. (e.g., julia --project src/Main.jl 4,6 -3,3)")
        return nothing
    end

    return Interval(max, min)
end

function displayHelp()
    println("\nWelcome to 1 Dimensional Grid Problem Solver! 

To proceed please enter two grids, grid A and grid B, in form:
julia --project src/Main.jl min_A,max_A min_B,max_B \n
Example: julia --project src/Main.jl 4,6 -3,3 
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

    k, scaled_solutions, solutions = solve(A, B)
    println("Solutions: ")
    for i = 1:length(solutions)
        println("(1 + √2)^-$(k) * ($(scaled_solutions[i].a) + $(scaled_solutions[i].b)√2) = ", solutions[i])
    end

end

main()