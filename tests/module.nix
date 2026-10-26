# The NixOS / Home Manager module (nix/module.nix).
{
  lib,
  base24,
  fixtures,
  modules,
}:

let
  inherit (fixtures) base16Theme fails;
  inherit (base24) themes;

  # Evaluate a module the way NixOS / Home Manager would. Both declare a
  # `lib` option; it is stubbed here.
  evalModule =
    module: settings:
    (lib.evalModules {
      modules = [
        module
        {
          options.lib = lib.mkOption {
            type = lib.types.attrsOf lib.types.attrs;
            default = { };
          };
        }
        settings
      ];
    }).config;

  nixos = evalModule modules.nixos { };
  homeManager = evalModule modules.homeManager { base24.customTheme = base16Theme; };
  disabled = evalModule modules.nixos { base24.enable = false; };
in
{
  defaultTheme =
    nixos.lib ? base24
    && nixos.lib.base24.getColor "base05" == themes.birdland.base05
    && nixos.lib.base24.colors.base00 == themes.birdland.base00
    && lib.hasInfix "pragma Singleton" nixos.lib.base24.qml;

  customTheme =
    homeManager.lib ? base24
    && homeManager.lib.base24.getColor "base0D" == "dddddd"
    && homeManager.lib.base24.colors.base16 == "dddddd";

  disabled = !(disabled.lib ? base24);

  rejectsUnknownTheme = fails (
    (evalModule modules.nixos { base24.theme = "does-not-exist"; }).base24.theme
  );
}
