using ChargeFlipPhaser, GLMakie

include("homometric.jl")

function example_monitor()
    

    dd= Homometric.generate_difdata(30.0)

    # Create a phaser with the generated diffraction data and a form factor function
    formfactors = formfactors_synthetic(dd, ball_autocorr)

    phaser = Phaser(dd, formfactors)
    pm = PhasingMonitor(phaser)

    # Add a panel to the phasing monitor     
    s = Cut2D([2 0; 0 2], [0., 0.], (1024, 1024))
    add_panel!(pm, (1, 1), s, "Homometric structures example", 1.0)

    Base.display(pm.fig)
    do_phasing!(phaser, hooks=MonitorHooks(pm),
        algorithm=SweepDown(fraction_flipped=0.7, decrement=0.995), max_iterations=1000)
end

example_monitor()