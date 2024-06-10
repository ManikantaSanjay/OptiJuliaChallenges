using JuMP, GLPK

function solve_knapsack_problem(weights, values, capacity)
    # Check that input arrays are consistent
    if length(weights) != length(values)
        error("Weights and values must have the same number of elements.")
    end

    # Initialize the model using GLPK optimizer
    model = Model(GLPK.Optimizer)

    # Declare binary variables for item selection
    @variable(model, item_selected[1:length(weights)], Bin)

    # Constraint: Total weight of selected items must not exceed the capacity
    @constraint(model, sum(item_selected[i] * weights[i] for i in 1:length(weights)) <= capacity)

    # Objective: Maximize the total value of selected items
    @objective(model, Max, sum(item_selected[i] * values[i] for i in 1:length(values)))

    # Solve the optimization model
    optimize!(model)

    # Check if a feasible solution has been found
    if termination_status(model) == MOI.OPTIMAL
        max_value = objective_value(model)
        selected_items = value.(item_selected)
        return max_value, selected_items
    else
        println("No feasible solution found.")
        return -1, []
    end
end

function print_solution(max_value, selected_items)
    println("Maximum value: ", max_value)
    println("Items selected: ", selected_items)
end

# Example data
weights = [10, 20, 30]
values = [60, 100, 120]
capacity = 50

# Solving the problem
max_value, selected_items = solve_knapsack_problem(weights, values, capacity)

# Printing the solution
print_solution(max_value, selected_items)
