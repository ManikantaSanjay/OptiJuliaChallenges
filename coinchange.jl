## Leetcode 322. Coin Change

using JuMP, GLPK

function minCoins(coins, amount)
    model = Model(GLPK.Optimizer)

    @variable(model, x[1:length(coins)] >= 0, Int)  # Non-negative integer variables

    # Objective: Minimize the number of coins
    @objective(model, Min, sum(x))

    # Constraint: Sum of coins times their denominations must equal the amount
    @constraint(model, sum(x[i] * coins[i] for i in 1:length(coins)) == amount)

    # Solve the model
    optimize!(model)

    # Check if a feasible solution exists
    if termination_status(model) == MOI.OPTIMAL
        return Int(objective_value(model))  # Return the minimum number of coins
    else
        return -1  # No solution found
    end
end

# Example usage
coins = [1, 5, 10]
amount = 12
println("Minimum coins needed: ", minCoins(coins, amount))

coins = [1]
amount = 0
println("Minimum coins needed: ", minCoins(coins, amount))