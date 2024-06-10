using Compose, JuMP, GLPK, DataFrames, XLSX, Graphs, GraphPlot, Colors

function run()
    #read inputs
    dfNodes = DataFrame(XLSX.readtable("input.xlsx", "nodes"))
    dfArcs = DataFrame(XLSX.readtable("input.xlsx", "arcs"))

    #parameters and sets
    D = dfArcs.distance
    nodeOrigin = first(dfNodes[dfNodes.description.=="origin", "node"])
    nodeDest = first(dfNodes[dfNodes.description.=="destination", "node"])
    nodeMiddle = dfNodes[dfNodes.description.=="middle point", "node"]
    setNodes = dfNodes.node
    setArcs = dfArcs.arc
    nNodes = nrow(dfNodes)
    nArcs = nrow(dfArcs)

    #model
    model = Model(GLPK.Optimizer)

    #variables
    x = @variable(model, [setArcs], Bin, base_name = "x")

    #objective function
    @objective(model, Min, sum(x[a] * D[a] for a in setArcs))

    #constraints
    nodesExitingOrigin = dfArcs[dfArcs.from.==nodeOrigin, "arc"]
    nodesEnteringDest = dfArcs[dfArcs.to.==nodeDest, "arc"]
    @constraint(model, sum(x[a] for a in nodesExitingOrigin) == 1)
    @constraint(model, sum(x[a] for a in nodesEnteringDest) == 1)
    @constraint(model, [n = nodeMiddle], sum(x[a] for a in dfArcs[dfArcs.from.==n, "arc"]) == sum(x[a] for a in dfArcs[dfArcs.to.==n, "arc"]))

    #optimize
    set_optimizer_attribute(model, "msg_lev", GLPK.GLP_MSG_ALL)
    optimize!(model)

    #print solution
    println("status = ", termination_status(model))
    println("OF (total distance)= ", objective_value(model))

    dfArcs.activated = zeros(nArcs)

    for a in setArcs
        dfArcs[a, "activated"] = value(x[a])
    end

    println(dfArcs)

    return dfArcs

end

function plot_network(dfArcs)
    # Number of nodes can be assumed or extracted if you have node data
    sort!(dfArcs, [:from, :to])
    num_nodes = maximum([maximum(dfArcs.from), maximum(dfArcs.to)])

    # Create a directed graph
    g = DiGraph(num_nodes)

    # Ensure edges are added in the correct order and direction as per dfArcs
    for row in eachrow(dfArcs)
        add_edge!(g, row.from, row.to)
    end

    # Determine the edge color based on the 'activated' status
    # Only edges where activated == 1.0 are blue, otherwise gray
    edge_color = [row.activated == 1.0 ? colorant"blue" : colorant"gray" for row in eachrow(dfArcs)]


    # Plot configuration
    node_label = 1:num_nodes  # Adjust if you have specific labels

    # Identify source and destination nodes (assuming single source and single destination)
    source_node = minimum(dfArcs.from)  # assuming the smallest 'from' value
    destination_node = maximum(dfArcs.to)  # assuming the largest 'to' value

    # Initialize node colors
    node_color = [colorant"gray" for _ in 1:num_nodes]
    node_color[source_node] = colorant"red"
    node_color[destination_node] = colorant"green"


    # Extract distances for edge labels
    edge_labels = [string(row.distance) for row in eachrow(dfArcs)]

    # Use gplot with a layout function directly
    gp = gplot(g, nodelabel=node_label, nodefillc=node_color, edgestrokec=edge_color, edgelabel=edge_labels, edgelabeldistx=1.5, edgelabeldisty=0.5, layout=spring_layout)

    # Save the plot to a file using Compose
    draw(SVG("routing.svg", 16cm, 16cm), gp)
end

# Call the plotting function with your DataFrame of arcs
# Execute functions
dfArcs = run()
plot_network(dfArcs)