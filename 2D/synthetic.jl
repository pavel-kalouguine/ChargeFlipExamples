using StaticArrays, ChargeFlipPhaser, SpaceGroups, LinearAlgebra, GLMakie

include(joinpath(@__DIR__, "..", "savers", "json_saver.jl"))

function synthetic_amplitudes(k::SVector{2,Int})
    dir=[1, (sqrt(5)-1)/2] # The direction of the "atomic surfaces"
    # Positions, weights and widths of "atomic surfaces" in the unit cell
    atoms=[(SA[0.2, 0.1], 1.0, 0.4), (SA[0.7, 0.3], 0.5, 0.2), (SA[0.4, 0.8], 0.8, 0.25)]
    return sum(a * exp.(2π * im * k ⋅ r) * sinc(w * k ⋅ dir) for (r, a, w) in atoms)
end

function generate_difdata(r::Real)
    G = SpaceGroupQuotient{2,Int}() # trivial space group
    md = SMatrix{2,2,Float64}([1.0 0.0; 0.0 1.0]) # The lattice unit cell happen to be square
    dd = DiffractionData(G, md)
    n = Int(floor(r))
    for kx = 0:n, ky = -n:n
        if (kx != 0 || ky > 0) && (kx^2 + ky^2 < r^2)
            k = SVector{2,Int}([kx, ky])
            f = synthetic_amplitudes(k)
            i = add_peak!(dd, k, abs(f)^2)
        end
    end
    dd
end

function example_monitor()
    

    dd= generate_difdata(30.0)

    # Create a phaser with the generated diffraction data and a form factor function
    formfactors = formfactors_synthetic(dd, ball_autocorr)

    phaser = Phaser(dd, formfactors)
    pm = PhasingMonitor(phaser)

    # Add a panel to the phasing monitor     
    s = Cut2D([2 0; 0 2], [0., 0.], (1024, 1024))
    add_panel!(pm, (1, 1), s, "Synthetic data example", 1.0)

    Base.display(pm.fig)

    output = joinpath(@__DIR__, "results", "synthetic.json")
    do_phasing!(phaser, hooks=MonitorHooks(pm),
        algorithm=SweepDown(fraction_flipped=0.7, decrement=0.99), saver=JSONSaver(output))
end

example_monitor()