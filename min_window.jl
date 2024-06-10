## Leetcode 76. Minimum Window Substring

using JuMP, GLPK

function findMinWindowOptimal(s, t)
    model = Model(GLPK.Optimizer)
    n = length(s)

    @variable(model, x[1:n], Bin)  # x[i] = 1 if the i-th char is part of the window

    # Objective: Minimize the window size
    @variable(model, l, Int)
    @variable(model, r, Int)
    @objective(model, Min, r - l + 1)

    # Constraints to ensure that l and r are the bounds of the window
    @constraint(model, [i = 1:n], l - i <= (1 - x[i]) * n)  # l is less or equal to the smallest i selected
    @constraint(model, [i = 1:n], r - i >= -(1 - x[i]) * n)  # r is greater or equal to the largest i selected

    # Ensure l and r are within the actual indices used
    @constraint(model, l >= 1)
    @constraint(model, r <= n)

    # Ensure the selected window contains at least the required count of each character in t
    countT = Dict(c => count(==(c), t) for c in unique(t))
    for (char, cnt) in countT
        @constraint(model, sum(x[i] for i in 1:n if s[i] == char) >= cnt)
    end

    # Solve the model
    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL
        opt_l = value(l)
        opt_r = value(r)
        return s[Int(opt_l):Int(opt_r)]
    else
        return ""  # No solution found
    end
end

# Example usage
s = "abcdef"
t = "fade"
println(findMinWindowOptimal(s, t))
