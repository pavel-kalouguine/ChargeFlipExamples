using ChargeFlipPhaser, StaticArrays, Plots

include(joinpath(@__DIR__, "load_cdyb.jl"))
include(joinpath(@__DIR__, "load_znmgtm.jl"))


function fraction_filled(dd::DiffractionData; ntries=100)
    nk = length(dd.k_to_bp)
    ns = Int[]
    for i = 1:100
        (v, maxproj) = ChargeFlipPhaser.find_injective_projector(CdYb.dd)
        n = nextprod((2, 3, 5, 7), 2 * (maxproj + 1))
        push!(ns, n)
    end
    nk ./ ns
end

ff1 = fraction_filled(CdYb.dd)
ff2 = fraction_filled(ZnMgTm.dd)

stephist(ff1, bins=20, line=:solid, label="CdYb", linewidth=2, color=:black, xlabel="filling factor")
stephist!(ff2, bins=20, line=:dash, label="ZnMgTm", linewidth=2, color=:black)