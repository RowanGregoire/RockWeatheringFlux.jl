# RockWeatheringFlux.jl
Estimate the composition of the continental crust, and correlate this estimate with erosion rate to estimate volume and composition of eroded material.

In addition to performing computations and defining its own functions, RockWeatheringFlux reexports:

* [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl)
* [StatGeochem.jl](https://github.com/brenhinkeller/StatGeochem.jl)
* [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl): `@showprogress`, `Progress`, `next!`

# Getting started
On start-up, this code calls bash commands to organize subdirectories, and has only been extensively tested on Linux machines. I expect it to work on macOS, but it may error on Windows machines. It is possible to run the Julia code on Windows, but it may require some manual set-up.

The repo will automatically:
- Create directories using `mkdir -p` to keep output files organized. This might work on Windows... but it might not. You could go through `src/utilities/Definitions.jl` and edit the CLI commands to work on Windows, but it might be faster just to create the directories yourself. Alternatively, use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
- Download the ETOPO1 or SRTM15+ data files from the [StatGeochem.jl](https://github.com/brenhinkeller/StatGeochem.jl) Google API.

If running the code from GitHub, you will have to manually add:
- The `combined.tsv` file to the `data/` directory.
- (OPTIONAL) The `crn_basins_global.kml.gz` to the `data/octopus/` directory. Alternatively, use `output/basins/octopusdata.tsv`. 

These files are included, and can be found in, the version of the repo archived on [OSF](https://doi.org/10.17605/OSF.IO/3RAFH).

# Running the code

On a Unix operating system, run `demos/make_new_results.sh` to run the code from start to finish. This may take a couple days.

## Set-up and data aquisition 
The following can be done in any order:
- Get geologic maps from the [Macrostrat](https://macrostrat.org/) API, run `src/ParseMacrostrat.jl`. If you're requesting the full 1,000,000 samples, this may take a couple days. By default, the script saves intermediate files every 100,000 samples. Samples should be sorted into rock types each time there's an intermediate save, but if you want to re-do the rock type sorting, run `src/ReclassMacrostrat.jl`.
- Calibrate the slope / erosion model by running `src/SRTMSlope.jl` to calculate the maximum slope in each SRTM15+ cell. Then run `src/ModelSlope.jl` to calibrate the slope / erosion model. Do note:
    - Processing the OCTOPUS ([10.5194/essd-14-3695-2022](doi.org/10.5194/essd-14-3695-2022)) data runs the Bash `gunzip` command, which may not work on a Windows machine. I haven't found a good workaround, so users can load an intermediate file (`output/basins/octopusdata.tsv`) instead. This will also save a good amount of time. 
    - Slope / erosion mode values are hardcoded in the `emmkyr()` function because values don't change between runs, and I'm lame and don't want to re-run the erosion model every time I go to calculate something. 
- Screen the geochemical dataset (`data/combined.tsv`) for whole-rock geochemistry and sort samples into rock types, run `src/ScreenCombined.jl`.
- Screen the GloRiSe river chemistry dataset from Müller et al., 2021 ([10.5194/essd-13-3565-2021](doi.org/10.5194/essd-13-3565-2021)), which will be used to compare REE composition.

## Generating results
Match geochemical samples to geologic map units with `src/SampleMatch.jl`.

Then in any order, 
- Run `src/CalculateFlux.jl` to calculate the eroded material mass flux, composition, and fractional contribution to mass flux by lithology.
- Run `src/UpperCrustComposition.jl` to calculate the composition of exposed continental crust.
- Run `src/SurfaceLithology.jl` to calculate the surficial exposure of each lithology by continent.

# Output
If you're interested in where a specific figure or table came from:

## Figures
All figures live in the `visualization/composition/` subdirectory. This is ommitted from the filepaths below, to save space.

Main text:
- Figure 1: `ModelComparison.jl` (A) and `Spidergram.jl` (B - C)
- Figure 2: `ModelComparison.jl` (A) and `Spidergram.jl` (B)
- Figure 3: `SilicaDistribution.jl` (A - C) and `SilicaAgeDistribution.jl`  (D - I)

Supplemental materials:
- Figure S1: N/A
- Figure S2: `MatchedSimilarity.jl`
- Figure S3: `SlopeErosion.jl`
- Figure S4: `SilicaDistribution.jl`

## Tables
Main text:
- Table 1: `src/UpperCrustComposition.jl`
- Table 2: `src/UpperCrustComposition.jl`
- Table 3: `src/CalculateFlux.jl`

Supplemental materials: 
- Table S1: `src/SurfaceLithology.jl`
- Table S2: `src/UpperCrustComposition.jl`

## Supplemental datasets
- Data S1: `src/UpperCrustComposition.jl`
- Data S2: `src/SurfaceLithology.jl`
- Data S3: `src/CalculateFlux.jl`
- Data S4: `src/CalculateFlux.jl`
- Data S5: `src/CalculateFlux.jl`
- Data S6: `src/UpperCrustComposition.jl`
