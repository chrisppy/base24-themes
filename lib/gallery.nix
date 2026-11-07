# docs/gallery.md: every bundled theme's card, three to a row, each linking to
# docs/<name>.md. Regenerate with:
#   nix eval --raw .#lib.base24.gallery > docs/gallery.md
{
  lib,
  core,
  themes,
}:

let
  names = builtins.attrNames themes;

  cell =
    name:
    let
      title = lib.escapeXML (core.getMeta themes.${name}).name;
    in
    ''
      <td align="center" valign="top">
      <a href="./${name}.md"><img src="../previews/cards/${name}.svg" alt="${title}" width="260"></a><br>
      <a href="./${name}.md"><strong>${title}</strong></a>
      </td>
    '';

  rows = lib.genList (i: lib.sublist (i * 3) 3 names) ((builtins.length names + 2) / 3);
  row = cells: "<tr>\n" + lib.concatMapStrings cell cells + "</tr>\n";
in
''
  ## Gallery

  Every bundled theme at a glance. Select one for its full palette.

  <table>
  ${lib.concatMapStrings row rows}</table>

  This page is generated: run
  `nix eval --raw .#lib.base24.gallery > docs/gallery.md` after adding a theme.
''
