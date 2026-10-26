# The base24-themes library. Pure: it needs only a nixpkgs `lib`, so it works
# with or without flakes:
#
#   base24 = import "${base24-themes}/lib" { inherit (pkgs) lib; };
#
# The flake exposes the same attrset as `lib.base24`.
{ lib }:

let
  core = import ./core.nix { inherit lib; };
  format = file: import file { inherit lib core; };

  formats = {
    toYaml = format ./formats/yaml.nix;
    toJson = format ./formats/json.nix;
    toScss = format ./formats/scss.nix;
    toQml = format ./formats/qml.nix;
    toSvg = format ./formats/svg.nix;
  };

  themes = import ./themes.nix { inherit lib; };
in
core
// formats
// {
  inherit themes;

  # SVG previews shown in the README. Regenerate one with:
  #   nix eval --raw .#lib.base24.previews.birdland > previews/birdland.svg
  previews = builtins.mapAttrs (_: formats.toSvg) themes;
}
