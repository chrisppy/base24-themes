# Validation, fallbacks and color access (lib/core.nix).
{ base24, fixtures, ... }:

let
  inherit (fixtures) base16Theme extendedTheme fails;
  normalized = base24.normalizeTheme base16Theme;
  normalizedExtended = base24.normalizeTheme extendedTheme;
in
{
  allFallbacksCorrect =
    normalized.base10 == "000000"
    && normalized.base11 == "000000"
    && normalized.base12 == "888888"
    && normalized.base13 == "aaaaaa"
    && normalized.base14 == "bbbbbb"
    && normalized.base15 == "cccccc"
    && normalized.base16 == "dddddd"
    && normalized.base17 == "eeeeee";

  explicitColorsPreserved =
    normalizedExtended.base10 == "101010" && normalizedExtended.base12 == "121212";

  uppercaseColorsLowered =
    (base24.normalizeTheme (base16Theme // { base0A = "AbCdEf"; })).base0A == "abcdef";

  colorNamesMatch =
    builtins.length (builtins.attrNames (base24.getColors base16Theme)) == 24
    && builtins.length base24.colorNames == 24;

  colorHelpersWork =
    base24.getColor base16Theme "base05" == "555555"
    && base24.getColorHex base16Theme "base05" == "#555555";

  missingColorFails = fails (base24.normalizeTheme (removeAttrs base16Theme [ "base00" ]));
  unknownColorFails = fails (base24.getColor base16Theme "baseFF");
  invalidColorFails = fails (base24.normalizeTheme (base16Theme // { base05 = "not-a-color"; }));
  shortColorFails = fails (base24.normalizeTheme (base16Theme // { base05 = "fff"; }));
  hashPrefixedColorFails = fails (base24.normalizeTheme (base16Theme // { base05 = "#555555"; }));
  invalidVariantFails = fails (base24.normalizeTheme (base16Theme // { variant = "dim"; }));
}
