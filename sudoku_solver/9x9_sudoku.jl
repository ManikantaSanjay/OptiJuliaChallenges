## Leetcode 37. Sudoku Solver
using JuMP, Cbc

function setup_sudoku_model(sudoku_grid)
    model = Model(Cbc.Optimizer)
    @variable(model, x[i=1:9, j=1:9, k=1:9], Bin)
    return model
end

function add_sudoku_constraints!(model, sudoku_grid)
    # Constraint 1: Each cell contains a single integer
    @constraint(model, [i = 1:9, j = 1:9], sum(model[:x][i, j, :]) == 1)

    # Constraint 2: Each integer k appears once in each row
    @constraint(model, [k = 1:9, i = 1:9], sum(model[:x][i, :, k]) == 1)

    # Constraint 3: Each integer k appears once in each column
    @constraint(model, [k = 1:9, j = 1:9], sum(model[:x][:, j, k]) == 1)

    # Constraint 4: Each integer k appears once in each 3x3 submatrix
    for block_row in 0:2
        for block_col in 0:2
            for k = 1:9
                @constraint(model, sum(model[:x][1+3*block_row:3*(block_row+1), 1+3*block_col:3*(block_col+1), k]) == 1)
            end
        end
    end

    # Constraint 5: Preset elements are set "on"
    for i in 1:9
        for j in 1:9
            if sudoku_grid[i, j] != 0
                @constraint(model, model[:x][i, j, sudoku_grid[i, j]] == 1)
            end
        end
    end
end

function solve_sudoku(model)
    @objective(model, Min, 0)
    optimize!(model)
    return JuMP.termination_status(model) == MOI.OPTIMAL
end

function extract_solution(model)
    solution = zeros(Int, 9, 9)
    for i in 1:9, j in 1:9, k in 1:9
        if JuMP.value(model[:x][i, j, k]) > 0.9  # because it's a binary variable
            solution[i, j] = k
        end
    end
    return solution
end

function print_sudoku(grid)
    for row in 1:9
        println(join([grid[row, col] == 0 ? "." : string(grid[row, col]) for col in 1:9], " "))
    end
end

function main()
    sudoku_grid = [
        5 3 0 0 7 0 0 0 0;
        6 0 0 1 9 5 0 0 0;
        0 9 8 0 0 0 0 6 0;
        8 0 0 0 6 0 0 0 3;
        4 0 0 8 0 3 0 0 1;
        7 0 0 0 2 0 0 0 6;
        0 6 0 0 0 0 2 8 0;
        0 0 0 4 1 9 0 0 5;
        0 0 0 0 8 0 0 7 9
    ]

    model = setup_sudoku_model(sudoku_grid)
    add_sudoku_constraints!(model, sudoku_grid)

    if solve_sudoku(model)
        solution = extract_solution(model)
        println("Original Sudoku Grid:")
        print_sudoku(sudoku_grid)

        println("\nSolved 9x9 Sudoku Grid:")
        print_sudoku(solution)
    else
        println("No solution found!")
    end
end

main()
