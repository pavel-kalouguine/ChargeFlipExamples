# Examples of scipts for ChargeFlipPhaser

## Installation
Clone the project to a local folder:
```
git clone https://github.com/pavel-kalouguine/ChargeFlipExamples
```

Launch julia in the project folder and add [PKPackages](https://github.com/pavel-kalouguine/PKPackages) registry in the package manager (press `]` in Julia REPL to switch to Pkg REPL):
```
pkg> registry add https://github.com/pavel-kalouguine/PKPackages
```

Activate the local environment and instantiate the project:
```
(@v1.11) pkg> activate .
(ChargeFlipExamples) pkg> instantiate
```

## Running examples
You can run examlples as Julia scripts:
- `icosahedral/monitor_cdyb.jl` : A Gui monitor example of CdYb quasicrystal structure
- `icosahedral/script_cdyb.jl` : A script for CdYb phasing with text output
- `icosahedral/monitor_znmgtm.jl` : A Gui monitor example of ZnMgTM quasicrystal structure
- `icosahedral/script_znmgtm.jl` : A script for ZnMgTM phasing with text output
- `2D/monitor_homometric.jl` : An example of 2D homometric structures. This is a challenging task for the reference implementation of the algorithm (`SweepDown`), since in majority of the cases it tends to converge to a mixture of two homometric solutions.

Datasets correspond to these publications:
- Takakura, H., Gomez, C. P., Yamamoto, A., De Boissieu, M. & Tsai, A. P. (2007). *Nature materials*,
**6**(1), 58–63
- Buganski, I., Wolny, J. & Takakura, H. (2020). *Foundations of Crystallography*, **76**(2), 180–196.

