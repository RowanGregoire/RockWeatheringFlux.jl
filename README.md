# RockWeatheringFlux.jl
Estimate the composition of the continental crust, and correlate this estimate with erosion rate to estimate volume and composition of eroded material.

In addition to performing computations and defining its own functions, RockWeatheringFlux reexports:

* [Measurements.jl](https://github.com/JuliaPhysics/Measurements.jl)
* [StatGeochem.jl](https://github.com/brenhinkeller/StatGeochem.jl)
* [ProgressMeter.jl](https://github.com/timholy/ProgressMeter.jl): `@showprogress`, `Progress`, `next!`

## Running the Code
Some setup and definitions file (e.g. `src/utilities/Definitions.jl`) call bash commands in order to create directories, which causes errors on Windows machines. The easiest way to run this code on these machines is to use [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install).
