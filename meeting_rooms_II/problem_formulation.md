## Problem Formulation for Leetcode 253: Meeting Rooms II

### Objective
The task is to determine the minimum number of meeting rooms required to accommodate all given meeting intervals without any overlaps. This scheduling problem is formulated as a Mixed-Integer Linear Programming (MILP) problem using JuMP and the GLPK solver to optimize room allocation.

### Variables
- **`x[i, d]` (Binary Variable):** Represents whether meeting `i` is held on day `d` (1 if yes, 0 otherwise).
- **`day_used[d]` (Binary Variable):** Indicates if any meeting is held on day `d` (1 if yes, 0 otherwise).

### Constraints
1. **Single Scheduling Constraint:**
   - Each meeting `i` must be scheduled exactly once. This is enforced by ensuring the sum of `x[i, d]` across all possible days `d` equals 1.

2. **Non-overlapping Constraint:**
   - No two meetings `i` and `j` that overlap can occur on the same day. For each pair of overlapping meetings, it is ensured that `x[i, d] + x[j, d] <= 1` for each day `d`.

3. **Day Usage Linking:**
   - The `day_used[d]` variables are linked to the `x[i, d]` variables to ensure that a day is marked as used if at least one meeting is scheduled on that day. This is done via the constraint `sum(x[i, d] for i in 1:n) <= n * day_used[d]`.

### Objective Function
- **Minimize `sum(day_used[d] for d in 1:max_days)`:** Aims to minimize the total number of days used, effectively reducing the required number of meeting rooms.

### Solver Configuration
- **GLPK Solver:** Configured to solve the MILP efficiently. Attributes like message level (`msg_lev`) can be adjusted for more verbose solver output.

### Execution and Result
- The model is optimized using the `optimize!` function. If the solver finds an optimal solution:
  - The function returns the total number of days (meeting rooms) used, which is the minimal number of rooms required.
  - If no feasible solution exists (e.g., due to solver limits or problem constraints), the function returns `-1`.
