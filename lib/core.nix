# Theme validation and color access. Pure: needs only a nixpkgs `lib`.
{ lib }:

let
  colorNames = [
    "base00"
    "base01"
    "base02"
    "base03"
    "base04"
    "base05"
    "base06"
    "base07"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
    "base10"
    "base11"
    "base12"
    "base13"
    "base14"
    "base15"
    "base16"
    "base17"
  ];

  base16Names = lib.take 16 colorNames;

  # Used only when a theme omits a Base24 extension color (i.e. a Base16 theme).
  # base10/base11 fall back to base00, so the "darker" backgrounds are flat
  # rather than inverted. Bundled themes must define all 24 colors.
  fallbacks = {
    base10 = "base00";
    base11 = "base00";
    base12 = "base08";
    base13 = "base0A";
    base14 = "base0B";
    base15 = "base0C";
    base16 = "base0D";
    base17 = "base0E";
  };

  variants = [
    "dark"
    "light"
  ];

  # Colors are six hex digits without a leading "#".
  isHexColor = value: builtins.isString value && builtins.match "[0-9a-fA-F]{6}" value != null;

in
rec {
  inherit colorNames;

  normalizeTheme =
    theme:
    let
      missing = builtins.filter (name: !(builtins.hasAttr name theme)) base16Names;
      invalid = builtins.filter (
        name: builtins.hasAttr name theme && !(isHexColor theme.${name})
      ) colorNames;
      describe = name: "${name} = ${builtins.toJSON theme.${name}}";
      variant = theme.variant or "dark";
      lowered = lib.genAttrs (builtins.filter (name: builtins.hasAttr name theme) colorNames) (
        name: lib.toLower theme.${name}
      );
      extended = builtins.mapAttrs (
        name: source: lowered.${name} or lowered.${source}
      ) fallbacks;
    in
    if missing != [ ] then
      throw "base24-themes: missing Base16 colors: ${lib.concatStringsSep ", " missing}"
    else if invalid != [ ] then
      throw "base24-themes: invalid hex colors (expected 6 hex digits, no '#'): ${lib.concatStringsSep ", " (map describe invalid)}"
    else if !(builtins.elem variant variants) then
      throw "base24-themes: invalid variant ${builtins.toJSON variant} (expected \"dark\" or \"light\")"
    else
      theme // lowered // extended;

  getColors = theme: lib.getAttrs colorNames (normalizeTheme theme);

  getColor =
    theme: name:
    if builtins.elem name colorNames then
      (normalizeTheme theme).${name}
    else
      throw "base24-themes: unknown color '${name}'";

  getColorHex = theme: name: "#${getColor theme name}";

  # Metadata shared by the structured exporters.
  getMeta =
    theme:
    let
      normalized = normalizeTheme theme;
    in
    {
      system = "base24";
      name = normalized.name or "Unnamed";
      author = normalized.author or "unknown";
      variant = normalized.variant or "dark";
    };
}
