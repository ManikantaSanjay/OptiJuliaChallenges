## Leetcode 416. Partition Equal Subset Sum
using JuMP, GLPK

function canPartitionOpt(nums)
    total_sum = sum(nums)
    if total_sum % 2 != 0
        return false
    end
    target = total_sum // 2

    model = Model(GLPK.Optimizer)
    @variable(model, x[1:length(nums)], Bin)  # Binary variables

    # Constraint: Sum of selected elements must be half of the total sum
    @constraint(model, sum(x[i] * nums[i] for i in 1:length(nums)) == target)

    # We only need to know if there is at least one feasible solution
    @objective(model, Min, 0)  # Dummy objective

    # Solve the model
    optimize!(model)
    return termination_status(model) == MOI.OPTIMAL
end

nums1 = [1, 5, 11, 5]
nums2 = [1, 2, 3, 5]

# Example usage
println("Can partition (Optimized): ", canPartitionOpt(nums1))  # Output: true
println("Can partition (Optimized): ", canPartitionOpt(nums2))  # Output: false