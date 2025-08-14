module ZnMgTm
# Data taken from https://journals.iucr.org/a/issues/2020/02/00/ae5079/index.html

using DataFrames, CSV, StaticArrays, LinearAlgebra
using ChargeFlipPhaser
include(joinpath(@__DIR__, "icosahedron.jl"))
using .Icosahedron

const datafilename = "ae5079sup2.txt"
const datafilepath = joinpath(@__DIR__, "data", datafilename)
const a = 5.128 # Icosahedral lattice parameter, Angstrems
const composition = [("Zn", 69.5), ("Mg", 20.9), ("Tm", 9.6)]
# Debye-Waller exponent, Angstrem^2. We use the value for metal zinc averaged par axes
# estimated from the plots found in http://dx.doi.org/10.1107/S2053273321005507
const B_factor = 1.2 
G = PI # The symmetry group

dd = DiffractionData(G, Icosahedron.epar * (π / a))
header = ["h1", "h2", "h3", "h4", "h5", "h6", "F_obs", "F_calc", "dExt"]
t = CSV.File(datafilepath; header=header, skipto=14, delim='\t')
dt = DataFrame(t)
for r in eachrow(dt)
    # Note the change of indexing convention
    k_raw = SVector{6,Int}(r.h1, r.h2, r.h3, r.h4, r.h6, -r.h5)
    k=infl*k_raw # Apparently, in the datafile the wavevectors were deflated    
    I = r.F_obs^2
    n = add_peak!(dd, k, I)
    if n == 0
        @warn "Wavevector $k_raw already added."
    end
end

function kpar(k::SVector{6, Int})
    base = Icosahedron.epar * (π / a)
    base * k
end
function kper(k::SVector{6, Int})
    base = Icosahedron.eper * (π / a)
    base * k
end

# Compute the formfactors to apply to the diffraction data
atomic_formfactor = WeightedF0(composition)
formfactors=ones(Float64, length(dd.bps))
# First, divide by the average atomic formfactor and the Debye-Waller factor to sharpen the atomic surfaces
for (i, bp) in enumerate(dd.bps)
    q = physicalnorm(bp.o.aps[1].k, dd)
    κ = q / (4 * π) # sin(θ)/λ
    formfactors[i] = 1.0/(atomic_formfactor(κ) * exp(-B_factor * κ^2))
end
# Then, apply the windoning function in the parallel and in the perp space
windowing_function=ball_autocorr
lim_kpar = maximum(norm(kpar(bp.o.aps[1].k)) for bp in dd.bps)*(1.0 + 1.0 / length(dd.bps))
lim_kper = maximum(norm(kper(bp.o.aps[1].k)) for bp in dd.bps)*(1.0 + 1.0 / length(dd.bps))
@info "max kpar $lim_kpar"
@info "max kper $lim_kper"
for (i, bp) in enumerate(dd.bps)
    formfactors[i] *= windowing_function(norm(kpar(bp.o.aps[1].k)) / lim_kpar)
    formfactors[i] *= windowing_function(norm(kper(bp.o.aps[1].k)) / lim_kper)
end
end