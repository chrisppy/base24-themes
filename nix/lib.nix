{ lib, ... }:

{
  flake.lib.base24 = import ../lib { inherit lib; };
}
