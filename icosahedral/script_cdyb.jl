using ChargeFlipPhaser, StaticArrays, LinearAlgebra

include(joinpath(@__DIR__, "load_cdyb.jl"))


phaser = Phaser(CdYb.dd, CdYb.formfactors)
struct ScriptHooks <: AbstractHooks end
ChargeFlipPhaser.on_show(::ScriptHooks, ::Phaser, extra::Dict) = @info extra

do_phasing!(phaser, algorithm=SweepDown(), hooks=ScriptHooks(), max_iterations=100)
