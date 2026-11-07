# Bundled themes (themes/), their previews and cards (previews/) and the
# gallery (docs/gallery.md).
{ base24, fixtures, ... }:

let
  inherit (base24) themes;
  inherit (fixtures) fails luminance;
  all = predicate: builtins.all predicate (builtins.attrValues themes);
in
{
  birdlandDiscovered = themes ? birdland;

  haveNames = all (theme: builtins.isString (theme.name or null));

  valid = all (theme: !(fails (base24.getColors theme)));

  # Bundled themes must define every color (no fallbacks) ...
  complete = all (theme: builtins.all (name: theme ? ${name}) base24.colorNames);

  # ... and keep the Base24 depth order: base11 <= base10 <= base00.
  depthOrder = all (
    theme:
    let
      c = base24.getColors theme;
    in
    luminance c.base11 <= luminance c.base10 && luminance c.base10 <= luminance c.base00
  );

  # previews/<theme>.svg must match `nix eval --raw .#lib.base24.previews.<theme>`.
  previewsUpToDate = builtins.all (
    name:
    let
      file = ../previews + "/${name}.svg";
    in
    builtins.pathExists file && builtins.readFile file == base24.previews.${name}
  ) (builtins.attrNames themes);

  # previews/cards/<theme>.svg must match `nix eval --raw .#lib.base24.cards.<theme>`.
  cardsUpToDate = builtins.all (
    name:
    let
      file = ../previews/cards + "/${name}.svg";
    in
    builtins.pathExists file && builtins.readFile file == base24.cards.${name}
  ) (builtins.attrNames themes);

  # Every bundled theme has a page, which the gallery links to.
  pagesExist = builtins.all (name: builtins.pathExists (../docs + "/${name}.md")) (
    builtins.attrNames themes
  );

  # docs/gallery.md must match `nix eval --raw .#lib.base24.gallery`.
  galleryUpToDate = builtins.readFile ../docs/gallery.md == base24.gallery;
}
