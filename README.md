# base24-themes

A collection of standardized [Base24](https://github.com/tinted-theming/base24) color schemes and Nix library functions designed for declarative desktop environments and dynamic styling.

## Features

* **Predefined Palettes**: Access a rich set of built-in Base24 themes ready for injection.
* **Format Converters**: Native utility functions (such as `toQml`) to translate color schemes into application-specific configuration formats.
* **Flake Native**: Fully integrated with Nix Flakes, supporting per-system and cross-platform evaluation.

---

## Installation

Add `base24-themes` as an input in your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base24-themes.url = "github:chrisppy/base24-themes";
  };

  outputs = { self, nixpkgs, base24-themes, ... }: {
    # Your flake outputs...
  };
}
```

---

## Usage & Library Functions

Access the library and apply theme transformers inside your derivations or modules:

```nix
{
  perSystem = { system, ... }: let
    base24Lib = inputs.base24-themes.lib.${system} or inputs.base24-themes.lib;
    qmlTheme = base24Lib.toQml inputs.base24-themes.themes.birdland;
  in {
    # Use qmlTheme in your packages or modules
  };
}
```

---

## Defining Your Own Custom Theme

Instead of using a predefined theme name string (like `"birdland"`), you can pass a custom attribute set matching the Base24 color specification directly to your modules or library converters:

```nix
{
  programs.birdland.theme.scheme = {
    base00 = "181818";
    base01 = "282828";
    base02 = "383838";
    base03 = "585858";
    base04 = "b8b8b8";
    base05 = "d8d8d8";
    base06 = "e8e8e8";
    base07 = "f8f8f8";
    base08 = "ab4642";
    base09 = "dc9656";
    base0A = "f7ca88";
    base0B = "a1b56c";
    base0C = "86c1b9";
    base0D = "7cafc2";
    base0E = "ba8baf";
    base0F = "a16946";
    # Base16 to Base24 extensions
    base10 = "101010";
    base11 = "202020";
    base12 = "303030";
    base13 = "404040";
    base14 = "505050";
    base15 = "606060";
    base16 = "707070";
    base17 = "808080";
  };
}
```

---

## Using Home Manager Modules

If you are consuming `base24-themes` via Home Manager or integrating its output modules into your configuration, import the provided module default:

```nix
{ inputs, ... }: {
  imports = [
    inputs.base24-themes.homeManagerModules.default
  ];

  # Modules enable dynamic scheme application natively across your HM suite
}
```

---

## License

This project is licensed under the **GPL-3.0-only** license. See the [LICENSE](./LICENSE) file for details.
