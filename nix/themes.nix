{ pkgs, lib, ... }:

let
  themesDir = ./../themes;

  # Helper to parse any YAML file into a Nix attrset
  readYaml =
    path:
    let
      jsonFile = pkgs.runCommand "yaml-to-json" { } ''
        ${pkgs.yq-go}/bin/yq eval -o=json '${path}' > $out
      '';
    in
    builtins.fromJSON (builtins.readFile jsonFile);

  # Read all .yaml files in the directory
  yamlFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".yaml" name) (
    builtins.readDir themesDir
  );

  # Map each file to [ { name = theme.name; value = path; } ]
  packagesList = lib.mapAttrsToList (
    fileName: _:
    let
      filePath = themesDir + "/${fileName}";
      themeData = readYaml filePath;
    in
    {
      inherit (themeData) name;
      value = filePath;
    }
  ) yamlFiles;
in
{
  perSystem.packages = builtins.listToAttrs packagesList;
}
