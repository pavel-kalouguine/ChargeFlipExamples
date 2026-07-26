using ChargeFlipPhaser, StaticArrays, LinearAlgebra

include(joinpath(@__DIR__, "load_cdyb.jl"))
include(joinpath(@__DIR__, "..", "savers", "json_saver.jl"))

phaser = Phaser(CdYb.dd, CdYb.formfactors)
output = joinpath(@__DIR__, "results", "CdYb.json")
do_phasing!(phaser, algorithm=SweepDown(), saver=JSONSaver(output), max_iterations=1000)
