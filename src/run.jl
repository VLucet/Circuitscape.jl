export compute

"""
`compute(path::String)`

Call the `compute` function on the configuration file.

Inputs:
======

* path::String - Path to configuration file

"""
function compute(path::String)
    cfg = parse_config(path)
    update_logging!(cfg)
    is_raster = cfg["data_type"] == "raster"
    scenario = cfg["scenario"]
    T = cfg["precision"] in SINGLE ? Float32 : Float64 
    if is_raster
        if scenario == "pairwise"
            raster_pairwise(T, cfg)
        elseif scenario == "advanced"
            raster_advanced(T, cfg)
        elseif scenario == "one-to-all"
            raster_one_to_all(T, cfg)
        else
            raster_one_to_all(T, cfg)
        end
    else
        if scenario == "pairwise"
            @code_warntype network_pairwise(T, cfg)
            network_pairwise(T, cfg)
        else
            @code_warntype network_advanced(T, cfg)
            network_advanced(T, cfg)
        end
    end
end