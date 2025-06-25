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
- `2D/monitor_homometric.jl` : An example of 2D homometric structures
