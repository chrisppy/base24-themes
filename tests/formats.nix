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
in
{
  yaml =
    lib.hasPrefix ''system: "base24"'' yaml
    && lib.hasInfix ''name: "Test"'' yaml
    && lib.hasInfix "palette:\n" yaml
    && lib.hasInfix ''  base00: "000000"'' yaml
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
}
