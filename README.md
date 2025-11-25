# RockWeatheringFlux.jl
Estimate the composition of the continental crust, and correlate this estimate with erosion rate to estimate volume and composition of eroded material.

In addition to performing computations and defining its own functions, RockWeatheringFlux reexports:

* [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl)
* [StatGeochem.jl](https://github.com/brenhinkeller/StatGeochem.jl)
* [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl): `@showprogress`, `Progress`, `next!`

## Running the Code
Some setup and definitions file (e.g. `src/utilities/Definitions.jl`) call bash commands in order to create directories, which causes errors on Windows machines. To run the full code on these machines, use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).

### Required file order: 

#### Start here to recalculate the slope / erosion model. 
The model parameters are hard-coded (because I'm lame and don't want to re-run the erosion model code every time I calculate anything), so to change the results, you will have to change the function in `src/utilities/Slope.jl`.

1. `src/SRTMSlope.jl` calculate maximum slope in each cell. 
2. `src/ModelSlope.jl` calibrate slope / erosion model.

#### Start here to generate all files from scratch.

3. `src/ParseMacrostrat.jl` request geologic map data from the Macrostrat API. This may take multiple days.

#### Start here to use existing data files, but re-do filtering or rock type assignments.

4. `src/ReclassMacrostrat.jl` re-sort existing Macrostrat data into rock types.
5. `src/ScreenCombined.jl` screen the combined dataset for whole-rock geochemistry, and sort the dataset into rock types.

#### Start here to use the existing Macrostrat and filtered geochemical datasets.

6. `src/SampleMatch.jl` match each spatial Macrostrat point to a geochemical sample.
7. `src/CalculateFlux.jl` calculate the composition and mass of eroded material.
8. `src/UpperCrustComposition.jl` calculate the composition of exposed continental crust, and what proportion of lithologies explains compositions of existing composition models.
9. `src/SurfaceLithology.jl` calculate the proportion of each rock type exposed on Earth's surface.
