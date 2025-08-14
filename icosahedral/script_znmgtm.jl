using ChargeFlipPhaser, StaticArrays, LinearAlgebra

include(joinpath(@__DIR__, "load_znmgtm.jl"))


phaser = Phaser(ZnMgTm.dd, ZnMgTm.formfactors)
struct ScriptHooks <: AbstractHooks end
function ChargeFlipPhaser.on_show(::ScriptHooks, phaser::Phaser, ρ::Vector{Float64}, iteration::Int) 
    limits=phaser.numamps.*extrema(ρ)
    @info "iteration=$iteration, limits=$limits"
end

@time do_phasing!(phaser, algorithm=SweepDown(), hooks=ScriptHooks(), max_iterations=100)
