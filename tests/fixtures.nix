# Shared test inputs and helpers.
{ lib }:

rec {
  base16Theme = {
    base00 = "000000";
    base01 = "111111";
    base02 = "222222";
    base03 = "333333";
    base04 = "444444";
    base05 = "555555";
    base06 = "666666";
    base07 = "777777";
    base08 = "888888";
    base09 = "999999";
    base0A = "aaaaaa";
    base0B = "bbbbbb";
    base0C = "cccccc";
    base0D = "dddddd";
    base0E = "eeeeee";
    base0F = "ffffff";
  };

  extendedTheme = base16Theme // {
    base10 = "101010";
    base12 = "121212";
  };

  # True when forcing `value` throws.
  fails = value: !(builtins.tryEval (builtins.deepSeq value true)).success;

  # Relative luminance weights; ordering is all that matters here.
  channel = hex: offset: lib.fromHexString (builtins.substring offset 2 hex);
  luminance = hex: 2126 * channel hex 0 + 7152 * channel hex 2 + 722 * channel hex 4;
}
