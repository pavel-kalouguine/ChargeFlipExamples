using ChargeFlipPhaser, StaticArrays, Statistics

module BenchmarkDeciles
using ChargeFlipPhaser
struct ScriptHooks <: AbstractHooks end
end 

include(joinpath(@__DIR__, "load_cdyb.jl"))

num_iter=100
deciles_history=Matrix{Float64}(undef, 11, num_iter)
phaser = Phaser(CdYb.dd, CdYb.formfactors)
function ChargeFlipPhaser.on_show(::BenchmarkDeciles.ScriptHooks, phaser::Phaser, ρ::Vector{Float64}, iteration::Int) 
    deciles=phaser.numamps.*quantile(ρ, 0.0:0.1:1.0)
    deciles_history[:, iteration]=deciles
    @info "iteration=$iteration"
end


do_phasing!(phaser, algorithm=SweepDown(), hooks=BenchmarkDeciles.ScriptHooks(), max_iterations=num_iter)
plot(deciles_history', color=:black, legend=false, xlabel="iterations")