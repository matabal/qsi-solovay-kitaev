module GridOperators

const rt2 = sqrt(2) 

abstract type GridOperator end

struct GridOperator_Standard <: GridOperator
    a::Int
    a_prime::Int
    b::Int
    b_prime::Int
    c::Int
    c_prime::Int
    d::Int
    d_prime::Int
end

struct GridOperator_Simple <: GridOperator
    a::Real
    b::Real
    c::Real
    d::Real
    GridOperator_Simple(operator::GridOperator_Standard) = new(operator.a+(operator.a_prime/rt2), operator.b+(operator.b_prime/rt2), operator.c+(operator.c_prime/rt2), operator.d+(operator.d_prime/rt2))
    GridOperator_Simple(a::Real, b::Real, c::Real, d::Real) = new(a, b, c, d)
end
getOperatorMatrix(operator::GridOperator_Simple) = [operator.a operator.b; operator.c operator.d]

function getOperatorMatrix(operator::GridOperator_Standard) 
    simple_form = GridOperator_Simple(operator)
    return getOperatorMatrix(simple_form)
end

end # module