# Every themes/<name>.nix, keyed by file name. `name` defaults to the file name.
{ lib }:

let
  themeDir = ../themes;

  themeFiles = lib.filterAttrs (
    name: type: (type == "regular" || type == "symlink") && lib.hasSuffix ".nix" name
  ) (builtins.readDir themeDir);
in
lib.mapAttrs' (
  filename: _:
  let
    key = lib.removeSuffix ".nix" filename;
  in
  lib.nameValuePair key ({ name = key; } // import (themeDir + "/${filename}"))
) themeFiles
