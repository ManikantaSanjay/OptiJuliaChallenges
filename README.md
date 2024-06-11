# OptiJuliaChallenges

Welcome to the Julia Optimization Challenges Repository, a collection of various problems (Leetcode and others) solved using Julia, a high-performance programming language designed for technical computing. The focus of this repository is on demonstrating the application of different optimization techniques and solvers to solve practical problems ranging from resource allocation to scheduling and decision making.

## Purpose

The purpose of this repository is to:
- Demonstrate how to model and solve complex optimization problems using Julia.
- Provide a practical application of various optimization solvers such as GLPK, CBC, and others.
- Serve as an educational tool for learning about optimization problems and their solutions in Julia.
- Offer a base for further exploration and development of more complex optimization models.

## Repository Structure

Each directory in the repository corresponds to a specific optimization problem. Below is a brief overview of each problem and the solver used:

### 1. 01_Knapsack
- **Solver Used**: GLPK
- **Description**: Solves the classic knapsack problem where the goal is to maximize the value of items placed in a knapsack while adhering to a weight constraint.
- [More details](./01_Knapsack)

### 2. Buy_Sell_Stock
- **Solver Used**: Couenne Solver through AmplNLWriter
- **Description**: Determines the best time to buy and sell a stock to maximize profit.
- [More details](./buy_sell_stock)

### 3. Coin_Change
- **Solver Used**: GLPK
- **Description**: Calculates the minimum number of coins needed to make up a certain amount of money.
- [More details](./coin_change)

### 4. Job_Scheduler
- **Solver Used**: GLPK
- **Description**: Optimizes job scheduling on multiple machines to minimize the total processing time.
- [More details](./job_scheduler)

### 5. Jump_Game
- **Solver Used**: CBC
- **Description**: Determines if it is possible to reach the end of an array where each element indicates the maximum jump length at that position.
- [More details](./jump_game)

### 6. Meeting_Rooms_II
- **Solver Used**: GLPK
- **Description**: Computes the minimum number of conference rooms required to hold all meetings without overlap.
- [More details](./meeting_rooms_II)

### 7. Minimum_Window_Substring
- **Solver Used**: GLPK
- **Description**: Finds the smallest substring in a string that contains all the characters of another string.
- [More details](./minimum_window_substring)

### 8. Partition_Equal_Subset_Sum
- **Solver Used**: GLPK
- **Description**: Checks if an array can be partitioned into two subsets such that the sum of elements in both subsets is equal.
- [More details](./partition_equal_subset_sum)

### 9. Routing_Problem
- **Solver Used**: GLPK
- **Description**: Optimizes routing paths in a network to minimize the total travel distance or cost.
- [More details](./routing_problem)

### 10. Sudoku_Solver
- **Solver Used**: CBC
- **Description**: Utilizes Mixed-Integer Programming (MIP) techniques to fill the Sudoku grid, following standard rules.
- [More details](./sudoku_solver)


## Installation and Setup

To run the projects in this repository, you need to install Julia and the necessary packages. Follow these steps:

1. Download and install Julia from the [official website](https://julialang.org/downloads/). 
I'm using verson 1.9.4
2. Open Julia and install the JuMP package and an appropriate solver by running:
   ```julia
   using Pkg
   Pkg.add("JuMP")
   Pkg.add("GLPK")  # Example for GLPK, replace with other solvers as needed
