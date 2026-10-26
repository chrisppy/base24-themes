# Runs every suite and returns { "<suite>.<test>" = bool; }.
#   base24:  the library (lib/)
#   modules: { nixos, homeManager } exported by the flake
{
  lib,
  base24,
  modules,
}:

let
  args = {
    inherit lib base24 modules;
    fixtures = import ./fixtures.nix { inherit lib; };
  };

  suites = {
    core = ./core.nix;
    formats = ./formats.nix;
    themes = ./themes.nix;
    module = ./module.nix;
  };
in
lib.concatMapAttrs (
  suite: file: lib.mapAttrs' (test: lib.nameValuePair "${suite}.${test}") (import file args)
) suites
