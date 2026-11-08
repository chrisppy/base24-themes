# Exporters (lib/formats/).
{
  lib,
  base24,
  fixtures,
  ...
}:

let
  inherit (fixtures) base16Theme;
  qml = base24.toQml (base16Theme // { variant = "light"; });
  yaml = base24.toYaml (base16Theme // { name = "Test"; });
  json = builtins.fromJSON (base24.toJson base16Theme);
  svg = base24.toSvg (base16Theme // { name = "A <&> B"; });
  card = base24.toCardSvg (base16Theme // { name = "A <&> B"; });
  # A light theme: base00 is white and base07 black.
  lightSvg = base24.toSvg (
    base16Theme
    // {
      variant = "light";
      base00 = "ffffff";
      base07 = "000000";
    }
  );
  cardColors = base24.getColors base16Theme;
in
{
  yaml =
    lib.hasPrefix ''system: "base24"'' yaml
    && lib.hasInfix ''name: "Test"'' yaml
    && lib.hasInfix "palette:\n" yaml
    && lib.hasInfix ''base00: "000000"'' yaml
    && lib.hasSuffix "\n" yaml;

  json =
    json.system == "base24"
    && json.variant == "dark"
    && json.palette.base00 == "000000"
    && builtins.length (builtins.attrNames json.palette) == 24;

  scss = lib.hasInfix "$base00: #000000;\n" (base24.toScss base16Theme);

  qml =
    lib.hasInfix "pragma Singleton" qml
    && lib.hasInfix "import QtQuick" qml
    && lib.hasInfix "QtObject {" qml
    && lib.hasInfix "Variant: light" qml
    && lib.hasInfix ''readonly property color base00: "#000000"'' qml
    && lib.hasInfix ''readonly property color base17: "#eeeeee"'' qml;

  qmlHasAllColors = builtins.all (
    name: lib.hasInfix "readonly property color ${name}:" qml
  ) base24.colorNames;

  svg =
    lib.hasPrefix "<svg " svg
    && lib.hasInfix "A &lt;&amp;&gt; B" svg
    && builtins.all (name: lib.hasInfix ">${name}<" svg) base24.colorNames;

  # Swatch labels stay readable when base00 is the light end: black on the
  # white base00 swatch, white on the black base07 swatch.
  svgLightInk =
    lib.hasInfix ''fill="#000000" font-size="13" font-weight="bold">base00<'' lightSvg
    && lib.hasInfix ''fill="#ffffff" font-size="13" font-weight="bold">base07<'' lightSvg;

  # A base16 theme gets a "base16" tag and a swatch for every (filled-in) color.
  card =
    lib.hasPrefix "<svg " card
    && lib.hasInfix "<title>A &lt;&amp;&gt; B</title>" card
    && lib.hasInfix ">base16<" card
    && builtins.all (
      name: lib.hasInfix "<title>${name} #${cardColors.${name}}</title>" card
    ) base24.colorNames;
}
