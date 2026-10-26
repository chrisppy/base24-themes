# A QML singleton. Register it in a qmldir file, e.g.
#   singleton Theme 1.0 Theme.qml
{ lib, core, ... }:

let
  inherit (core) colorNames normalizeTheme getMeta;
in
theme:
let
  normalized = normalizeTheme theme;
  inherit (getMeta theme) variant;
in
''
  // Generated from chrisppy/base24-themes
  // Variant: ${variant}
  // Do not edit manually.

  pragma Singleton
  import QtQuick

  QtObject {
  ${lib.concatMapStringsSep "\n" (
    name: "    readonly property color ${name}: \"#${normalized.${name}}\""
  ) colorNames}
  }
''
