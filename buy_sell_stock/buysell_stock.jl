## Leetcode 121. Best Time to Buy and Sell Stock
using JuMP, AmplNLWriter, Couenne_jll
function maximizeStockProfit(prices)
    n = length(prices)
    model = Model(() -> AmplNLWriter.Optimizer(Couenne_jll.amplexe))

    @variable(model, buy[1:n], Bin)
    @variable(model, sell[1:n], Bin)

    # Basic constraints: Only one buy and one sell
    @constraint(model, sum(buy) == 1)
    @constraint(model, sum(sell) == 1)

    # Must sell on a later day than you buy
    for i in 1:n
        for j in 1:i
            @constraint(model, buy[i] + sell[j] <= 1)
        end
    end

    # The objective function 
    @objective(model, Max, sum((prices[j] - prices[i]) * buy[i] * sell[j] for i in 1:n for j in i+1:n))

    optimize!(model)

    if termination_status(model) == MOI.OPTIMAL || termination_status(model) == MOI.LOCALLY_SOLVED
        if objective_value(model) > 0
            println("Maximum profit: $(objective_value(model))")
            for i in 1:n
                if value(buy[i]) > 0.5
                    println("Buy on day: $i")
                end
                if value(sell[i]) > 0.5
                    println("Sell on day: $i")
                end
            end
        else
            println("No profitable transaction is possible.")
        end
    else
        println("Solver failed or no solution was found.")
    end
end

# Example usage
prices1 = [3, 1, 4, 1, 5, 9, 2]
prices2 = [5, 4, 3, 2, 1]

maximizeStockProfit(prices1)
maximizeStockProfit(prices2)
