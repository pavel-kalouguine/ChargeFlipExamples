using ChargeFlipPhaser, Statistics, Plots

include(joinpath(@__DIR__, "load_cdyb.jl"))
include(joinpath(@__DIR__, "load_znmgtm.jl"))

num_iter=100
threshold=50.0



module BenchmarkConvergence
using ChargeFlipPhaser

struct ScriptHooks <: AbstractHooks 
    iconv::Ref{Int}
    isdone::Ref{Bool}
end

ScriptHooks()=ScriptHooks(Ref(0), Ref(false))
end

function ChargeFlipPhaser.on_show(hooks::BenchmarkConvergence.ScriptHooks, phaser::Phaser, ρ::Vector{Float64}, iteration::Int) 
    deciles=phaser.numamps.*quantile(ρ, 0.0:0.1:1.0)
    r=(deciles[11]-deciles[6])/(deciles[6]-deciles[1])
    #println(r)
    if r>50
        hooks.iconv[]=iteration
        hooks.isdone[]=true
    end
end

ChargeFlipPhaser.is_done(hooks::BenchmarkConvergence.ScriptHooks) = hooks.isdone[]


function n_iter_to_congerge(dd::DiffractionData, formfactors::Vector{Float64})::Int
    phaser = Phaser(dd, formfactors)
    hooks=BenchmarkConvergence.BenchmarkConvergence.ScriptHooks()
    do_phasing!(phaser, algorithm=SweepDown(decrement=0.99), hooks=hooks, max_iterations=num_iter)
    hooks.iconv[]
end

ntries=100
niter1=Int[]
niter2=Int[]
for i=1:ntries
    println(i)
    push!(niter1, n_iter_to_congerge(CdYb.dd, CdYb.formfactors))
    push!(niter2, n_iter_to_congerge(ZnMgTm.dd, ZnMgTm.formfactors))
end

stephist(niter1, bins=5.5:1.0:maximum(niter1)+0.5, line=:solid, label="CdYb", linewidth=2, color=:black, xlabel="iterations")
stephist!(niter2, bins=5.5:1.0:maximum(niter2)+0.5, line=:dash, label="ZnMgTm", linewidth=2, color=:black)