{ inputs, ... }:

{
  perSystem =
    { pkgs, ... }:

    let
      base24 = inputs.self.lib.base24;
      themes = inputs.self.themes;

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

      normalized = base24.normalizeTheme base16Theme;
      normalizedExtended = base24.normalizeTheme extendedTheme;

      missingColorFails =
        !(builtins.tryEval (
          builtins.deepSeq (base24.normalizeTheme (removeAttrs base16Theme [ "base00" ])) true
        )).success;

      unknownColorFails = !(builtins.tryEval (base24.getColor base16Theme "baseFF")).success;

      invalidColorFails =
        !(builtins.tryEval (
          builtins.deepSeq (base24.normalizeTheme (base16Theme // { base05 = "not-a-color"; })) true
        )).success;

      shortColorFails =
        !(builtins.tryEval (
          builtins.deepSeq (base24.normalizeTheme (base16Theme // { base05 = "fff"; })) true
        )).success;

      hashPrefixedColorFails =
        !(builtins.tryEval (
          builtins.deepSeq (base24.normalizeTheme (base16Theme // { base05 = "#555555"; })) true
        )).success;

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

      colorNamesMatch =
        builtins.length (builtins.attrNames (base24.getColors base16Theme)) == 24
        && builtins.length base24.colorNames == 24;

      colorHelpersWork =
        base24.getColor base16Theme "base05" == "555555"
        && base24.getColorHex base16Theme "base05" == "#555555";

      allDiscoveredThemesValid = builtins.deepSeq (builtins.mapAttrs (
        _: theme: base24.getColors theme
      ) themes) true;

      yamlHelperWorks = inputs.nixpkgs.lib.hasInfix "base00: \"000000\"" (base24.toYaml base16Theme);

      scssHelperWorks = inputs.nixpkgs.lib.hasInfix "$base00: #000000;" (base24.toScss base16Theme);

    in
    {
      checks.base24-themes =
        assert builtins.hasAttr "camden" themes;
        assert allFallbacksCorrect;
        assert explicitColorsPreserved;
        assert colorNamesMatch;
        assert colorHelpersWork;
        assert missingColorFails;
        assert unknownColorFails;
        assert invalidColorFails;
        assert shortColorFails;
        assert hashPrefixedColorFails;
        assert allDiscoveredThemesValid;
        assert yamlHelperWorks;
        assert scssHelperWorks;

        pkgs.runCommand "base24-themes-tests" { } ''
          touch "$out"
        '';
    };
}
