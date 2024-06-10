### Objective
The goal of this routing problem is to determine the optimal path from an origin node to a destination node in a network while passing through various middle points. The problem minimizes the total distance traveled and is modeled as a Mixed-Integer Linear Programming (MILP) problem using JuMP and the GLPK solver.

### Data Input
- **Nodes and Arcs:** Data about the nodes (origin, middle points, and destination) and the arcs (routes between nodes with distances) are read from an Excel file using the XLSX package.

### Variables
- **`x[a]` (Binary Variable):** Represents whether the arc `a` is included in the optimal route (1 if used, 0 otherwise).

### Constraints
1. **Unique Exit from Origin and Entry to Destination:**
   - Exactly one arc exiting the origin and one arc entering the destination must be selected.
   - This is enforced using the constraints `sum(x[a] for a in nodesExitingOrigin) == 1` and `sum(x[a] for a in nodesEnteringDest) == 1`.

2. **Flow Conservation at Middle Points:**
   - Ensures that the number of arcs entering a middle point equals the number of arcs exiting. This models the preservation of flow through the network.

### Objective Function
- **Minimize Total Distance:** The function minimizes the weighted sum of the arcs used, weighted by their respective distances, i.e., `sum(x[a] * D[a] for a in setArcs)`.

### Solver Configuration
- **GLPK Solver:** Configured for efficient solving of binary linear problems. Solver messages are set to display all outputs (`msg_lev` set to `GLPK.GLP_MSG_ALL`).

### Visualization
- After solving the optimization problem, the resulting network of activated routes (arcs) is visualized using Graphs and GraphPlot. Nodes and arcs are color-coded to indicate their role and status in the optimal solution:
  - **Red node:** Origin
  - **Green node:** Destination
  - **Blue edges:** Activated arcs
  - **Gray edges:** Inactive arcs

### Execution and Result
- The model is optimized using the `optimize!` function. The DataFrame of arcs, including whether each arc is activated in the optimal solution, is displayed and used for visualization.


# Function Definitions (run and plot_network as described above)

# Execute functions
dfArcs = run()
plot_network(dfArcs)