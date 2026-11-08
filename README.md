# base24-themes

[Base24](https://github.com/tinted-theming/base24) color schemes for Nix, with a
small library of format converters and a module for NixOS and Home Manager.

**[Usage & configuration options →](./docs/usage.md)**

**[Theme gallery →](./docs/gallery.md)**

## Features

- **Bundled themes**: ships with [`birdland`](./docs/birdland.md) (dark) and
  [`birdland-light`](./docs/birdland-light.md) (light), with more planned. Every file in `themes/` is picked up automatically.
- **Format converters**: `toYaml` (tinted-theming scheme format), `toJson`,
  `toScss`, `toQml`, `toSvg` (the palette preview images) and `toCardSvg` (the
  gallery cards).
- **Validation**: themes are checked for missing or malformed colors, and
  `nix flake check` verifies every bundled theme.
- **Module**: one module for NixOS and Home Manager that exposes the selected
  theme as `config.lib.base24`.

## Installation

Add `base24-themes` as an input in your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    base24-themes.url = "github:chrisppy/base24-themes";
    base24-themes.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, base24-themes, ... }: {
    # Your flake outputs...
  };
}
```

## Development

```sh
nix flake check   # run the tests (also run in CI on every push and pull request)
nix fmt           # format
```

```
lib/
  default.nix        library entry point (`lib.base24`)
  core.nix           validation, fallbacks, color access
  themes.nix         loads themes/
  gallery.nix        generates docs/gallery.md
  formats/           one file per exporter: yaml, json, scss, qml, svg, card
nix/                 flake-parts glue, loaded automatically
  lib.nix            exports lib.base24
  module.nix         NixOS / Home Manager module
  checks.nix         turns tests/ into `nix flake check`
tests/               one suite per area, plus shared fixtures
themes/              one file per theme
previews/            generated SVG previews (and cards/ for the gallery)
docs/                usage guide, theme pages and the gallery
```

To add a format, create `lib/formats/<name>.nix` (it receives `{ lib, core }`
and returns a `theme -> string` function), register it in `lib/default.nix` and
add a test to `tests/formats.nix`.

## License

MIT. See [LICENSE](./LICENSE).
