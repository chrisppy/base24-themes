{
  description = "A structured Base16/Base24 YAML theme flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    devfmt = {
      url = "github:chrisppy/devfmt";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.devfmt.inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.devfmt.inputs.systems;
      imports = [
        (inputs.devfmt.inputs.import-tree ./nix)
        inputs.devfmt.flakeModules.default
      ];

      perSystem = { system, ... }: {
        _module.args.pkgs = inputs.nixpkgs.legacyPackages.${system};
      };
    };
}
