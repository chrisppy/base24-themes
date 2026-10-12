{
  perSystem =
    { pkgs, lib, ... }:
    let
      themesDir = ./../themes;

      # Read all .yaml files in the directory
      yamlFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".yaml" name) (
        builtins.readDir themesDir
      );

      # Convert each YAML file into a derivation containing JSON
      packagesList = lib.mapAttrsToList (
        fileName: _:
        let
          filePath = themesDir + "/${fileName}";
          baseName = lib.removeSuffix ".yaml" fileName;
        in
        {
          name = baseName;
          value = pkgs.runCommand "theme-${baseName}.json" { } ''
            ${pkgs.yq-go}/bin/yq eval -o=json '${filePath}' > $out
          '';
        }
      ) yamlFiles;
    in
    {
      packages = builtins.listToAttrs packagesList;
    };
}
