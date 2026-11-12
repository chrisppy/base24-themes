# Changelog

All notable changes to base24-themes are recorded here. The format is based on
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

There are no tagged releases yet, so changes are grouped by date under
Unreleased. Routine flake input updates and formatting commits are left out.

## Unreleased

### 2026-11-08

#### Added

- [Birdland Light](./docs/birdland-light.md) theme: a cream background, charcoal
  text, and the Orioles accents deepened to reach 4.5:1 contrast on `base00` and
  `base01`.

#### Fixed

- SVG previews pick swatch label ink from whichever of `base00` and `base07` is
  the dark end, so labels are readable on light themes.

### 2026-11-07

#### Added

- Tinted-theming-style [gallery](./docs/gallery.md) cards: `toCardSvg`,
  `lib.base24.cards`, and the gallery page generated as `lib.base24.gallery`.
- Checks that the cards and gallery are up to date, and that every bundled theme
  has a docs page and a gallery entry.
- justfile.

#### Changed

- README split into [usage](./docs/usage.md), [Birdland](./docs/birdland.md) and
  [gallery](./docs/gallery.md) pages.

### 2026-10-25

#### Added

- `toJson`, `getMeta` and `toSvg` (palette and syntax sample previews).
- Module exported as `nixosModules.{base24,default}` and
  `homeManagerModules.{base24,default}`, with `theme` as an enum of bundled
  themes and `customTheme` as `attrsOf str`.
- Test suites for core, formats, themes and the module, and a CI workflow
  running `nix flake check`.
- README.

#### Changed

- **Breaking:** the top-level `themes` output moves to `lib.base24.themes`, with
  previews at `lib.base24.previews`.
- The library lives in `lib/` as pure Nix (needs only nixpkgs' `lib`, works
  without flakes), split into core, themes and one file per format.
- `toYaml` emits the tinted-theming scheme format. Colors are lowercased,
  `variant` is validated, and errors show the offending values.
- Birdland is tuned to the Orioles palette: `base08` is Orioles orange
  (`#df4601`), every accent reaches 4.5:1 contrast on `base00`, and bright
  variants are lighter than normals.

#### Fixed

- The exported module failed to evaluate; it is now a plain function using the
  library directly.
- Birdland's `base10` and `base11` are darker than `base00`, as Base24 requires.
- License in the README corrected to MIT, matching `LICENSE`.

### 2026-10-24

#### Changed

- **Breaking:** the Camden theme is renamed Birdland.

### 2026-10-18

#### Added

- `toQml` and more library functions, with tests.

#### Changed

- Themes are defined in Nix instead of YAML.

### 2026-10-12 to 2026-10-17

#### Changed

- Formatting moved to [devfmt](https://github.com/red-oxide/devfmt).
- Flake inputs are updated by a scheduled workflow.

### 2026-09-28 to 2026-09-29

- Initial commit, released under the MIT license.
