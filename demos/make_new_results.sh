#!/bin/bash
set -e  # Fail if any command fails 

# Lithology classifications and screening -- comment out to save some time if you trust 
# the existing sorting + screening that we've done. Re-do this if you want to double-check 
# anything or if you've changed any of the sorting algos or rock type wordbanks 
julia --project="Project.toml" src/ReclassMacrostrat.jl  # Macrostrat lithology
julia --project="Project.toml" src/ScreenCombined.jl     # Combined geochemistry 

# Using existing lith classes and geochemical screenings, re-run for results 
julia --project="Project.toml" src/SampleMatch.jl
julia --project="Project.toml" src/CalculateFlux.jl
julia --project="Project.toml" src/UpperCrustComposition.jl  
julia --project="Project.toml" src/SurfaceLithology.jl
