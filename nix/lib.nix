_:

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

  base16Names = builtins.genList (i: builtins.elemAt colorNames i) 16;

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

  isHexColor =
    value:
    builtins.isString value
    && builtins.stringLength value == 6
    && builtins.match "[0-9a-fA-F]{6}" value != null;

  base24 = rec {
    inherit colorNames;

    normalizeTheme =
      theme:
      let
        missing = builtins.filter (name: !(builtins.hasAttr name theme)) base16Names;

        invalid = builtins.filter (
          name: builtins.hasAttr name theme && !(isHexColor theme.${name})
        ) colorNames;

        extended = builtins.mapAttrs (
          name: source: if builtins.hasAttr name theme then theme.${name} else theme.${source}
        ) fallbacks;
      in
      if missing != [ ] then
        throw "base24-themes: missing Base16 colors: ${builtins.concatStringsSep ", " missing}"
      else if invalid != [ ] then
        throw "base24-themes: invalid hex colors: ${builtins.concatStringsSep ", " invalid}"
      else
        theme // extended;

    getColors =
      theme:
      let
        normalized = normalizeTheme theme;
      in
      builtins.listToAttrs (
        map (name: {
          inherit name;
          value = normalized.${name};
        }) colorNames
      );

    getColor =
      theme: name:
      let
        normalized = normalizeTheme theme;
      in
      if builtins.elem name colorNames then
        normalized.${name}
      else
        throw "base24-themes: unknown color '${name}'";

    getColorHex = theme: name: "#${getColor theme name}";

    toYaml =
      theme:
      let
        normalized = normalizeTheme theme;
      in
      builtins.concatStringsSep "\n" (map (name: "${name}: \"${normalized.${name}}\"") colorNames);

    toScss =
      theme:
      let
        normalized = normalizeTheme theme;
      in
      builtins.concatStringsSep "\n" (
        map (name: "$" + name + ": #" + normalized.${name} + ";") colorNames
      );
  };
in
{
  flake.lib.base24 = base24;
}
