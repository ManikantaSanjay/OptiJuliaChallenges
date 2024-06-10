using JuMP, GLPK

# Example items with weights and values
weights = [10, 20, 30]
values = [60, 100, 120]
capacity = 50

# Model setup
model = Model(GLPK.Optimizer)
@variable(model, x[1:length(weights)], Bin)  # Binary variables

# Constraint: Total weight must not exceed capacity
@constraint(model, sum(x[i] * weights[i] for i in 1:length(weights)) <= capacity)

# Objective: Maximize total value
@objective(model, Max, sum(x[i] * values[i] for i in 1:length(values)))

# Solve the model
optimize!(model)
println("Maximum value: ", objective_value(model))
println("Items selected: ", value.(x))