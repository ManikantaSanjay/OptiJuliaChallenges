## Leetcode 253. Meeting Rooms II
using JuMP, GLPK

function minMeetingDays(intervals)
    n = length(intervals)
    model = Model(GLPK.Optimizer)

    # Upper bound on the number of days, theoretically one day per meeting
    max_days = n

    # Binary variable x[i, d] if meeting i is on day d
    @variable(model, x[1:n, 1:max_days], Bin)

    # Additional binary variable to check if any meeting is held on a particular day
    @variable(model, day_used[1:max_days], Bin)

    # Constraint: Each meeting must be scheduled exactly once
    @constraint(model, [i = 1:n], sum(x[i, d] for d in 1:max_days) == 1)

    # Constraint: No two overlapping meetings should be on the same day
    for i in 1:n, j in i+1:n
        if intervals[i][2] > intervals[j][1] && intervals[j][2] > intervals[i][1]
            @constraint(model, [d = 1:max_days], x[i, d] + x[j, d] <= 1)
        end
    end

    # Linking day_used variables to x variables
    @constraint(model, [d = 1:max_days], sum(x[i, d] for i in 1:n) <= n * day_used[d])

    # Objective: Minimize the number of days used
    @objective(model, Min, sum(day_used[d] for d in 1:max_days))

    # Solve the model
    #optimize
    set_optimizer_attribute(model, "msg_lev", GLPK.GLP_MSG_ALL)
    optimize!(model)

    # Return the minimal number of days required
    if termination_status(model) == MOI.OPTIMAL
        return objective_value(model)
    else
        return -1  # No solution found
    end
end

# Example usage
intervals1 = [(0, 40), (5, 10), (15, 20)]
intervals2 = [(4, 9)]

println("Minimum days needed for intervals1: ", minMeetingDays(intervals1))
println("Minimum days needed for intervals2: ", minMeetingDays(intervals2))
