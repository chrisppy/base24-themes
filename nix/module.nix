{ config, lib, ... }:

let
  inherit (lib) mkIf mkOption types;

  themes = import ./_themes.nix { inherit lib; };
  themeLib = import ./_lib.nix;

  cfg = config.base24;

  selectedTheme =
    if cfg.customTheme != null then
      cfg.customTheme
    else if builtins.hasAttr cfg.theme themes then
      themes.${cfg.theme}
    else
      throw "base24: unknown theme '${cfg.theme}'";

  normalized = themeLib.normalizeTheme selectedTheme;
in
{
  flake.nixosModules.base24 = {
    options.base24 = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Base24 theme exports.";
      };

      theme = mkOption {
        type = types.str;
        default = "camden";
        description = "Name of a discovered theme.";
      };

      customTheme = mkOption {
        type = types.nullOr types.attrs;
        default = null;
        description = "Custom inline Base16 or Base24 theme.";
      };
    };

    config = mkIf cfg.enable {
      lib.base24 = {
        inherit themes;
        selected = normalized;
        colors = themeLib.getColors selectedTheme;

        getColor = name: themeLib.getColor selectedTheme name;

        inherit (themeLib) normalizeTheme;
        inherit (themeLib) getColors;
      };
    };
  };
}
