## Library

Everything lives at `lib.base24`: the functions, the bundled themes
(`lib.base24.themes.<name>`) and their preview images
(`lib.base24.previews.<name>`). It is system-independent.

```nix
let
  base24 = inputs.base24-themes.lib.base24;
  theme = base24.themes.birdland;
in
{
  qml = base24.toQml theme;   # QML singleton
  yaml = base24.toYaml theme; # tinted-theming scheme
  json = base24.toJson theme;
  scss = base24.toScss theme;
  bg = base24.getColorHex theme "base00"; # "#0b0b0b"
}
```

| Function | Returns |
| ------------------------------------------------ | ------------------------------------------------------------------------------ |
| `normalizeTheme theme` | The theme with all 24 colors filled in and lowercased; throws on invalid input |
| `getColors theme` | An attrset of just the 24 colors |
| `getColor theme name` / `getColorHex theme name` | One color, without or with a leading `#` |
| `toYaml`, `toJson`, `toScss`, `toQml` | The theme as a string in that format |
| `toSvg theme` | A preview image: palette swatches plus a highlighted code sample |

`toQml` produces a `pragma Singleton` file. Register it in a `qmldir` next to
it, for example `singleton Theme 1.0 Theme.qml`.

The library needs only a nixpkgs `lib`, so it also works without flakes:

```nix
base24 = import "${base24-themes-source}/lib" { inherit (pkgs) lib; };
```

## Defining your own theme

A theme is a flat attrset of `base00`–`base17`, plus optional `name`, `author`
and `variant` (`"dark"` or `"light"`, default `"dark"`). Colors are six hex
digits **without** a leading `#`.

```nix
{
  name = "My Theme";
  author = "me";
  variant = "dark";
  base00 = "181818"; # background
  base01 = "282828";
  base02 = "383838";
  base03 = "585858";
  base04 = "b8b8b8";
  base05 = "d8d8d8"; # foreground
  base06 = "e8e8e8";
  base07 = "f8f8f8";
  base08 = "ab4642"; # red
  base09 = "dc9656"; # orange
  base0A = "f7ca88"; # yellow
  base0B = "a1b56c"; # green
  base0C = "86c1b9"; # cyan
  base0D = "7cafc2"; # blue
  base0E = "ba8baf"; # magenta
  base0F = "a16946"; # brown
  # Base24 extensions
  base10 = "101010"; # darker background (not lighter than base00)
  base11 = "0c0c0c"; # darkest background (not lighter than base10)
  base12 = "d0605c"; # bright red
  base13 = "fbd9a6"; # bright yellow
  base14 = "bbcf88"; # bright green
  base15 = "a3d5cd"; # bright cyan
  base16 = "9cc8da"; # bright blue
  base17 = "d3a9ca"; # bright magenta
}
```

Base16 themes (only `base00`–`base0F`) are accepted too. The missing colors fall
back to `base00` for `base10`/`base11` and to the matching normal color for
`base12`–`base17`.

To bundle a theme, add it as `themes/<name>.nix`. Its key is the file name, and
`name` defaults to it. Bundled themes must define all 24 colors and need a
preview image:

```sh
nix eval --raw .#lib.base24.previews.<name> > previews/<name>.svg
```

`nix flake check` fails if a preview is missing or out of date.

## NixOS and Home Manager module

The same module is exported as `nixosModules.default` and
`homeManagerModules.default`:

```nix
{ inputs, config, ... }: {
  imports = [ inputs.base24-themes.homeManagerModules.default ];

  base24.theme = "birdland";
  # or: base24.customTheme = { base00 = "181818"; ... };

  # Use the colors anywhere in your configuration:
  # config.lib.base24.colors.base05     -> "d8d8d8"
  # config.lib.base24.getColorHex "base0D"
  # config.lib.base24.qml               -> QML singleton source
}
```

| Option | Default | Description |
| -------------------- | ------------ | --------------------------------------- |
| `base24.enable` | `true` | Expose the theme as `config.lib.base24` |
| `base24.theme` | `"birdland"` | A bundled theme name |
| `base24.customTheme` | `null` | An inline theme; overrides `theme` |

The module only exposes colors. It does not configure any applications itself.
