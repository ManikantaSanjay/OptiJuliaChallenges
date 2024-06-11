## Problem Formulation

### Variables
- **`x[i,j,k]` (Binary Variable):** Represents whether cell `(i, j)` contains the number `k` (1 if true, 0 otherwise).

### Constraints
1. **Each cell contains a single integer:** Every cell in the 9x9 grid must contain exactly one integer from 1 to 9.
2. **Each integer appears once in each row:** Each number must appear exactly once in each row.
3. **Each integer appears once in each column:** Each number must appear exactly once in each column.
4. **Each integer appears once in each 3x3 submatrix:** Each number must appear exactly once in each of the nine 3x3 submatrices.
5. **Preset elements are set:** If a cell in the initial grid contains a number, this number is fixed in the solution.

### Model Setup
The model is set up and solved using the Cbc solver, a popular open-source MIP solver. The problem is modeled with binary variables and linear constraints which are inherently suitable for MIP solvers.

### Solver Configuration
- **Model:** `Model(Cbc.Optimizer)` initializes the model with the Cbc solver.
- **Variable Definition:** Binary variables are defined for each possible number in each cell.
- **Constraints:** Constraints are added to ensure each row, column, and block contains each number once, and that predefined numbers remain fixed.

## Execution and Results
- The model is solved using the `optimize!` function. If the solver finds an optimal solution, the filled Sudoku grid is printed.
- If the solver determines that the Sudoku puzzle is unsolvable (i.e., no feasible solution exists), it prints "No solution found!"
