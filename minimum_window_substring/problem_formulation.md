## Problem Formulation for Leetcode 76: Minimum Window Substring

### Objective
The goal is to find the shortest substring within string `s` that contains all the characters in string `t`, including duplicates. This problem is modeled as a Mixed-Integer Linear Programming (MILP) problem using JuMP and GLPK, where the objective is to minimize the length of this substring.

### Variables
- **`x[i]` (Binary Variable):** Indicates whether the character at index `i` in string `s` is included in the window (1) or not (0).
- **`l`, `r` (Integer Variables):** Represent the starting and ending indices of the substring in `s`. These decision variables define the boundaries of the window.

### Objective Function
- **Minimize `(r - l + 1)`:** The function aims to minimize the length of the window, calculated as the difference between the end and start indices plus one, ensuring the substring length is directly optimized.

### Constraints
1. **Window Bound Constraints:**
   - **Start Boundary (`l`):** Ensures that `l` is less than or equal to the smallest index `i` selected in the window (`x[i] = 1`). 
   - **End Boundary (`r`):** Ensures that `r` is greater than or equal to the largest index `i` selected.
   - These are enforced using the constraints `l - i <= (1 - x[i]) * n` and `r - i >= -(1 - x[i]) * n` for all indices `i`, where `n` is the length of `s`.

2. **Character Inclusion Constraints:**
   - For each unique character `c` in `t`, there is a constraint ensuring that the sum of `x[i]` for all indices `i` where `s[i] = c` is at least as large as the count of `c` in `t`.
   - This ensures that the window contains at least as many of each required character as specified in `t`.

### Solver Configuration
- **GLPK Optimizer:** A linear programming solver used to find an optimal solution to the MILP. It manages the binary nature of `x[i]` and the integer constraints on `l` and `r`.

### Execution and Result
- The model is solved using the `optimize!` function. If the model finds an optimal solution (checked via `termination_status(model)`), it returns the substring from `s` from `l` to `r`. If no feasible solution exists, it returns an empty string.