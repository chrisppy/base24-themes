# Tinted-theming scheme format (system/name/author/variant + palette).
{ lib, core, ... }:

let
  inherit (core) colorNames normalizeTheme getMeta;
in
theme:
let
  normalized = normalizeTheme theme;
  meta = getMeta theme;
  quote = builtins.toJSON; # JSON strings are valid YAML double-quoted strings
in
lib.concatStringsSep "\n" (
  [
    "system: ${quote meta.system}"
    "name: ${quote meta.name}"
    "author: ${quote meta.author}"
    "variant: ${quote meta.variant}"
    "palette:"
  ]
  ++ map (name: "  ${name}: ${quote normalized.${name}}") colorNames
)
+ "\n"
