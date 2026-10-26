# The theme metadata plus a `palette` attrset, as JSON.
{ lib, core }:

let
  inherit (core) getMeta getColors;
in
theme: builtins.toJSON (getMeta theme // { palette = getColors theme; })
