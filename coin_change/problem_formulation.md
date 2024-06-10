### Objective
The problem requires finding the minimum number of coins needed to make up a given amount, where each coin's denomination is specified. It is modeled as a linear programming problem using JuMP and the GLPK solver to optimize the decision process.

### Variables
- **`x[i]` (Integer Variable):** Represents the number of coins of the `i`-th denomination used. These variables are constrained to be non-negative integers.

### Constraints
- **Exact Amount Match:** Ensures that the total value of the coins selected equals the desired amount. This is enforced by the constraint `sum(x[i] * coins[i] for i in 1:length(coins)) == amount`, where `coins[i]` represents the denomination and `x[i]` represents the number of such coins used.

### Objective Function
- **Minimize `sum(x)`:** The function aims to minimize the total number of coins used, summed over all denominations. This directly targets reducing the count of coins to meet the amount exactly.

### Solver Configuration
- **GLPK Solver:** A Linear Programming solver used to find the optimal solution to the defined problem. It is chosen for its efficiency in handling integer optimization problems.

### Execution and Result
- The model is solved using the `optimize!` function. If the solver finds an optimal solution:
  - The function returns the total number of coins used, which is the optimal objective value.
  - If no feasible solution exists (it's impossible to make up the amount with the given denominations), the function returns `-1`.