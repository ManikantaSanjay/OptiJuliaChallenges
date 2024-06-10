using JuMP, GLPK, Plots

function run()
    model = Model(GLPK.Optimizer)

    # Declare sets
    machines = [1, 2]
    jobs = [1, 2, 3]

    # Declare parameters
    T = Dict((1, 1) => 2, (1, 2) => 4, (1, 3) => 3,
        (2, 1) => 1, (2, 2) => 100, (2, 3) => 2)

    # Declare variables
    x = @variable(model, [machines, jobs], Bin, base_name = "x")
    s = @variable(model, [machines, jobs], lower_bound = 0, base_name = "s")
    e = @variable(model, [machines, jobs], lower_bound = 0, base_name = "e")
    emax = @variable(model, lower_bound = 0, base_name = "emax")

    # Objective function and constraints...
    @objective(model, Min, emax)
    @constraint(model, [j = jobs], sum(x[m, j] for m in machines) == 1)
    @constraint(model, x[2, 2] == 0)
    @constraint(model, [m = machines, j = jobs], e[m, j] >= s[m, j] + x[m, j] * T[m, j])
    @constraint(model, [m = machines, j = jobs], emax >= e[m, j])
    for m in machines, n in machines, j in jobs
        if j != minimum(jobs)
            @constraint(model, s[m, j] >= s[n, j-1])
        end
    end
    @constraint(model, [m = machines, n = machines], s[m, 2] >= e[n, 1] + 1.5)

    # Solve the problem
    optimize!(model)

    # Gather results for plotting
    job_starts = []
    job_durations = []
    machine_job_pairs = []
    for j in jobs
        for m in machines
            if value(x[m, j]) > 0.5
                push!(job_starts, value(s[m, j]))
                push!(job_durations, T[m, j])

                push!(machine_job_pairs, (m, j))
            end
        end
    end

    # Check if job_starts is empty before plotting
    if isempty(job_starts)
        println("No jobs were scheduled. Please check the model constraints and parameters.")
        return
    end

    # Plotting the schedule
    plt = plot()
    colors = [:blue, :green, :red, :cyan, :magenta, :yellow, :black, :orange]
    for i in eachindex(job_starts)
        m, j = machine_job_pairs[i]
        color = colors[(m-1)*length(jobs)+j]
        plot!(plt, [job_starts[i], job_starts[i] + job_durations[i]], [m, m], label="Machine $m Job $j",
            linewidth=10, linecolor=color)
        annotate!(job_starts[i] + job_durations[i] / 2, m, text("Job $j", 8, :center, :white))
    end

    xlabel!("Time")
    ylabel!("Machines")
    title!("Job Schedule on Machines")
    ylims!(plt, 0, length(machines) + 1)
    xlims!(plt, 0, maximum(job_starts .+ job_durations))

    # Save the plot to a file
    savefig(plt, "job_schedule_plot.png")
end

run()









