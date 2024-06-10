## Problem Formulation for Leetcode 121: Best Time to Buy and Sell Stock

### Objective
The task is to maximize the profit from a single transaction (one buy and one sell), where you must buy before you sell. This problem is formulated as a Mixed-Integer Linear Programming (MILP) problem using JuMP and Couenne solver through AmplNLWriter.

### Variables
- **`buy[i]` (Binary Variable):** Indicates whether to buy stock on day `i` (1 if buy, 0 otherwise).
- **`sell[i]` (Binary Variable):** Indicates whether to sell stock on day `i` (1 if sell, 0 otherwise).

### Constraints
1. **Single Transaction Constraints:**
   - **Exactly One Buy:** Ensures that exactly one day is selected for buying the stock.
   - **Exactly One Sell:** Ensures that exactly one day is selected for selling the stock.
   - **Order of Transactions:** A sell must occur on a day after the buy. This is enforced by the constraint `buy[i] + sell[j] <= 1` for all days `j` less than or equal to `i`, ensuring that selling cannot happen on the same day or before buying.

### Objective Function
- **Maximize `(prices[j] - prices[i]) * buy[i] * sell[j]`:** The function maximizes the profit, calculated as the difference between the selling price and buying price, summed over all possible pairs of days `(i, j)` where `j > i`. The binary variables ensure that the profit is calculated only if a buy and a sell actually occur.

### Solver Configuration
- **Couenne Solver through AmplNLWriter:** A global optimization solver that can handle non-convex MILP problems, which is suitable for cases where the interaction between the decision variables (binary products) might not be straightforward or linear.

### Execution and Result
- The model is solved using the `optimize!` function. If the solver finds an optimal or a locally optimal solution indicating profitable transactions:
  - The maximum profit and the corresponding days to buy and sell are displayed.
  - If the maximum calculated profit is zero or negative, it suggests that no profitable transaction is possible.
- If the solver fails or no feasible solution is found, appropriate messages are displayed.