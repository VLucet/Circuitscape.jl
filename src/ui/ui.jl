using Blink
using WebIO
using Tachyons
using CSSUtil
using JSExpr

include("pairwise_ui.jl")
include("advanced_ui.jl")
include("output_ui.jl")

w = Window()

function generate_ui(w)

    heading = Node(:div, tachyons_css, "Circuitscape 5.0") |> 
                    class"f-subheadline lh-title tc red"

    section1 = Node(:div, tachyons_css, "Data Type and Modelling Mode") |> 
                    class"f4 lh-title"

    dt = get_data_type()

    mod_mode_network = get_mod_mode_network()
    mod_mode_raster = get_mod_mode_raster()

    # Next drop down
    mod_mode = map(dt["value"]) do v
        if v == "Network"
            mod_mode_network
        else
            mod_mode_raster
        end
    end

    # Get the input raster/graph 
    input_section = Node(:div, tachyons_css, "Input Resistance Data") |> 
                    class"f4 lh-title"
    input = input_ui()
    
    # Focal points or advanced mode
    pair = pairwise_input_ui()
    adv = advanced_input_ui()
    #=points_input = Observable{Any}(Node(:div))
    map!(points_input, mod_mode) do s
        v = s["value"]
        tmp = Observable{Any}(Node(:div))
        map!(tmp, v) do x 
            @show x
            if x == "Pairwise"
                pair
            elseif x == "Advanced"
                adv
            elseif x == "One To All"
                pair
            elseif x == "All To One"
                pair
            end
        end
        tmp
    end

    @show points_input=#
    
    # Output options
    output = output_ui()

    page = vbox(heading, 
                hline(style = :solid, w=5px)(style = Dict(:margin => 20px)), 
                section1,
                dt, 
                mod_mode, 
                hline(style = :solid, w=3px)(style = Dict(:margin => 10px)),
                input_section,
                input, 
                hline(style = :solid, w=3px)(style = Dict(:margin => 10px)),
                pair, 
                hline(style = :solid, w=3px)(style = Dict(:margin => 10px)),
                adv,
                hline(style = :solid, w=3px)(style = Dict(:margin => 10px)),
                output)|> class"pa3 system-sans-serif"

    body!(w, page)

end

function get_data_type()

    data_type_prompt = "Step 1: Choose your input data type: "

    # Select between raster and network
    data_type = vbox(Node(:div, data_type_prompt, 
                          attributes = Dict(:style => "margin-top: 12px")) |> class"b",
                 Node(:select, "Select Data Type", 
                 Node(:option, "Raster"), 
                 Node(:option, "Network"), id = "dt", 
                 attributes = Dict(:style => "margin-top: 12px; margin-bottom: 12px")))

    s = Scope()
    s.dom = data_type
    onimport(s, JSExpr.@js function ()
                 @var el = this.dom.querySelector("#dt")
                 el.onchange = (function ()
                        $(s["value"])[] = el.value
                    end)
             end)

    s
end

function get_mod_mode_network()
    
    mod_mode_prompt = "Step 2: Choose a Modelling Mode: "
    mod_mode = vbox(Node(:div, mod_mode_prompt, 
                          attributes = Dict(:style => "margin-top: 12px")) |> class"b",
                 Node(:select, "Select Modelling Mode", 
                 Node(:option, "Pairwise"), 
                 Node(:option, "Advanced"), id = "modelling", 
                 attributes = Dict(:style => "margin-top: 12px; margin-bottom: 12px")))

    s = Scope()
    s.dom = mod_mode
    onimport(s, JSExpr.@js function ()
                 @var el = this.dom.querySelector("#modelling")
                 el.onchange = (function ()
                        $(s["value"])[] = el.value
                    end)
             end)

    s
end

function get_mod_mode_raster()
    
    mod_mode_prompt = "Step 2: Choose a Modelling Mode: "
    mod_mode = vbox(Node(:div, mod_mode_prompt, 
                          attributes = Dict(:style => "margin-top: 12px")) |> class"b",
                 Node(:select, "Select Modelling Mode", 
                 Node(:option, "Pairwise"), 
                 Node(:option, "Advanced"), 
                 Node(:option, "One To All "), 
                 Node(:option, "All To One"), id = "modelling", 
                 attributes = Dict(:style => "margin-top: 12px; margin-bottom: 12px")))

    s = Scope()
    s.dom = mod_mode
    onimport(s, JSExpr.@js function ()
                 @var el = this.dom.querySelector("#modelling")
                 el.onchange = (function ()
                        $(s["value"])[] = el.value
                    end)
             end)
    s
end
generate_ui(w)