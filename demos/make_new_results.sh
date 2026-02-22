#!/bin/bash
set -e  # Fail if any command fails 

# Lithology classifications and screening -- comment out to save some time if you've already 
# gotten the initial datasets set up. 
julia --project="Project.toml" src/ParseMacrostrat.jl
julia --project="Project.toml" src/SRTMSlope.jl
julia --project="Project.toml" src/ModelSlope.jl
julia --project="Project.toml" src/ScreenCombined.jl 

# Uncomment to re-do the Macrostrat rock classification: 
# julia --project="Project.toml" src/ReclassMacrostrat.jl

# Using existing lith classes and geochemical screenings, re-run for results 
julia --project="Project.toml" src/SampleMatch.jl
julia --project="Project.toml" src/CalculateFlux.jl
julia --project="Project.toml" src/UpperCrustComposition.jl  
julia --project="Project.toml" src/SurfaceLithology.jl
