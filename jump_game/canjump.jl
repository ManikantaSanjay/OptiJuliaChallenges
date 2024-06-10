## Leetcode 55. Jump Game
using JuMP, Cbc

function canJump(nums)
    n = length(nums)
    model = Model(Cbc.Optimizer)
    @variable(model, x[1:n], Bin)

    # Start from the last index
    @constraint(model, x[n] == 1)

    # Adjusted constraints based on the Python logic
    for i in (n-1):-1:1
        # Constraint to determine if index i can reach the goal
        @constraint(model, sum(x[j] for j in (i+1):min(n, i + nums[i])) >= x[i])
    end

    # Objective: maximize reaching the goal (index 1)
    @objective(model, Max, x[1])
    optimize!(model)

    # We check if the first index can be reached
    return termination_status(model) == MOI.OPTIMAL && value(x[1]) == 1.0
end

# Example usage
nums1 = [2, 3, 1, 1, 4]
nums2 = [3, 2, 1, 0, 4]
println("Can You Jump? :", canJump(nums1))  # Expected Output: true
println("Can You Jump? :", canJump(nums2))  # Expected Output: false