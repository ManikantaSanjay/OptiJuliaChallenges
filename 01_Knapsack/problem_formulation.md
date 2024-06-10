### Objective
The objective of the knapsack problem is to select items with given weights and values to maximize the total value without exceeding the capacity of the knapsack. This problem is modeled using JuMP and solved using the GLPK solver.

### Data Input and Parameters
- **Items:** A list of items each with a specific weight and value.
- **Capacity:** The total weight capacity of the knapsack.

### Variables
- **`item_selected[i]` (Binary Variable):** Indicates whether item `i` is selected in the knapsack.

### Constraints
1. **Capacity Constraint:**
   - The total weight of the selected items must not exceed the knapsack's capacity: `sum(item_selected[i] * weights[i] for i in 1:length(weights)) <= capacity`.

### Objective Function
- **Maximize the total value:** `Max, sum(item_selected[i] * values[i] for i in 1:length(values))`.

### Execution and Results Interpretation
- The model is solved using the `optimize!` function. If a feasible solution is found, the maximum value achievable and the selection status of each item are output.
- Results help in understanding which items to select to maximize value while adhering to the capacity constraint.