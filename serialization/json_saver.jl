using ChargeFlipPhaser
import ChargeFlipPhaser: save_result
using JSON

struct JSONSaver <: AbstractSaver
    output_file_path::String
end

rational_pair(x::Rational) = [numerator(x), denominator(x)]

matrix_rows(m) = [collect(r) for r in eachrow(m)]

function encode_element(g)
    Dict("a" => matrix_rows(g.a), "b" => [rational_pair(x) for x in g.b])
end

function save_result(saver::JSONSaver, phaser::Phaser, wa::WorkingAmplitudes)
    dd = phaser.dd
    bps = dd.bps

    ampl = zeros(ComplexF64, length(bps))
    for i in eachindex(wa.f_r)
        j = phaser.real_orbits[i]
        ampl[j] = wa.f_r[i] * exp(2π * im * bps[j].o.aps[1].ϕ)
    end
    for i in eachindex(wa.f_c)
        j = phaser.complex_orbits[i]
        ampl[j] = wa.f_c[i] * exp(2π * im * bps[j].o.aps[1].ϕ)
    end

    reflections = [Dict(
        "k" => collect(bps[j].o.aps[1].k),
        "I" => bps[j].I,
        "ampl" => [real(ampl[j]), imag(ampl[j])],
    ) for j in eachindex(bps)]

    D, N = size(dd.md)
    payload = Dict(
        "dimensions" => Dict("N" => N, "D" => D),
        "space_group" => Dict(
            "order" => length(dd.G),
            "elements" => [encode_element(g) for g in dd.G],
        ),
        "metric" => Dict("md" => matrix_rows(dd.md)),
        "reflections" => reflections,
    )

    open(saver.output_file_path, "w") do io
        JSON.print(io, payload, 2)
    end
    @info "Results saved in $(saver.output_file_path)"
end
