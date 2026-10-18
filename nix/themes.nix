{ inputs, ... }:

let
  lib = inputs.nixpkgs.lib;
  themeDir = ../themes;

  themeFiles = lib.filterAttrs (name: type: type == "regular" && lib.hasSuffix ".nix" name) (
    builtins.readDir themeDir
  );

  themes = lib.mapAttrs' (
    filename: _:
    lib.nameValuePair (lib.removeSuffix ".nix" filename) (import (themeDir + "/${filename}"))
  ) themeFiles;
in
{
  flake.themes = themes;
}
