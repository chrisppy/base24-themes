{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;

  # Reuse the flake's own outputs so there is a single implementation.
  base24 = config.flake.lib.base24;
  inherit (base24) themes;

  # A NixOS / Home Manager module. It must be a function so that `config`
  # below is the consumer's configuration, not the flake-parts one.
  module =
    { config, ... }:
    let
      cfg = config.base24;
      selected = if cfg.customTheme != null then cfg.customTheme else themes.${cfg.theme};
      normalized = base24.normalizeTheme selected;
    in
    {
      options.base24 = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Expose the selected Base24 theme as `config.lib.base24`.";
        };

        theme = mkOption {
          type = types.enum (builtins.attrNames themes);
          default = "birdland";
          description = "Name of a bundled theme.";
        };

        customTheme = mkOption {
          type = types.nullOr (types.attrsOf types.str);
          default = null;
          description = "Inline Base16 or Base24 theme. Overrides `theme` when set.";
        };
      };

      config = mkIf cfg.enable {
        lib.base24 = base24 // {
          selected = normalized;
          colors = base24.getColors normalized;
          getColor = base24.getColor normalized;
          getColorHex = base24.getColorHex normalized;
          yaml = base24.toYaml normalized;
          json = base24.toJson normalized;
          scss = base24.toScss normalized;
          qml = base24.toQml normalized;
        };
      };
    };
in
{
  flake.nixosModules.base24 = module;
  flake.nixosModules.default = module;
  flake.homeManagerModules.base24 = module;
  flake.homeManagerModules.default = module;
}
