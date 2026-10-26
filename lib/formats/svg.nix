# Preview image: palette swatches plus a syntax-highlighted code sample.
# The README images in previews/ are generated with this (see `previews`).
{ lib, core, ... }:

let
  inherit (core) colorNames normalizeTheme getMeta;
in
theme:
let
  c = normalizeTheme theme;
  meta = getMeta theme;
  esc = lib.escapeXML;
  str = toString;

  margin = 24;
  size = 90;
  gap = 8;
  height = 64;
  width = margin * 2 + 8 * size + 7 * gap;

  channel = hex: offset: lib.fromHexString (builtins.substring offset 2 hex);
  isLight = hex: 299 * channel hex 0 + 587 * channel hex 2 + 114 * channel hex 4 > 125000;

  swatch =
    x: y: name:
    let
      hex = c.${name};
      ink = if isLight hex then c.base00 else c.base07;
    in
    ''
      <rect x="${str x}" y="${str y}" width="${str size}" height="${str height}" rx="6" fill="#${hex}" stroke="#${c.base02}"/>
      <text x="${str (x + 8)}" y="${str (y + 22)}" fill="#${ink}" font-size="13" font-weight="bold">${name}</text>
      <text x="${str (x + 8)}" y="${str (y + height - 12)}" fill="#${ink}" font-size="12">#${hex}</text>'';

  row =
    index: label: names:
    let
      y = 64 + index * 104;
    in
    ''
      <text x="${str margin}" y="${str (y + 14)}" fill="#${c.base04}" font-size="13">${label}</text>
    ''
    + lib.concatStrings (lib.imap0 (i: name: swatch (margin + i * (size + gap)) (y + 24) name) names);

  # Each line is a list of [ color text ] segments.
  sample = [
    [
      [
        "base03"
        "# Oriole Park at Camden Yards"
      ]
    ]
    [
      [
        "base0E"
        "def "
      ]
      [
        "base0D"
        "first_pitch"
      ]
      [
        "base05"
        "("
      ]
      [
        "base08"
        "team"
      ]
      [
        "base05"
        ": "
      ]
      [
        "base0A"
        "str"
      ]
      [
        "base05"
        ", "
      ]
      [
        "base08"
        "inning"
      ]
      [
        "base05"
        ": "
      ]
      [
        "base0A"
        "int"
      ]
      [
        "base05"
        " = "
      ]
      [
        "base09"
        "1"
      ]
      [
        "base05"
        ") -> "
      ]
      [
        "base0A"
        "Game"
      ]
      [
        "base05"
        ":"
      ]
    ]
    [
      [
        "base0E"
        "    if not "
      ]
      [
        "base08"
        "team"
      ]
      [
        "base05"
        ":"
      ]
    ]
    [
      [
        "base0E"
        "        raise "
      ]
      [
        "base0A"
        "ValueError"
      ]
      [
        "base05"
        "("
      ]
      [
        "base0B"
        "\"no lineup\\n\""
      ]
      [
        "base05"
        ")"
      ]
    ]
    [
      [
        "base0E"
        "    return "
      ]
      [
        "base0A"
        "Game"
      ]
      [
        "base05"
        "(home="
      ]
      [
        "base0B"
        "\"Orioles\""
      ]
      [
        "base05"
        ", innings="
      ]
      [
        "base09"
        "9"
      ]
      [
        "base05"
        " + "
      ]
      [
        "base08"
        "inning"
      ]
      [
        "base05"
        ")"
      ]
    ]
  ];

  codeTop = 64 + 3 * 104 + 8;
  lineHeight = 22;
  codeHeight = 24 + lineHeight * builtins.length sample;

  line =
    i: segments:
    ''<text x="${str (margin + 16)}" y="${
      str (codeTop + 30 + i * lineHeight)
    }" font-size="14" xml:space="preserve">''
    + lib.concatMapStrings (
      seg: ''<tspan fill="#${c.${builtins.elemAt seg 0}}">${esc (builtins.elemAt seg 1)}</tspan>''
    ) segments
    + "</text>\n";

  totalHeight = codeTop + codeHeight + margin;
in
''
  <svg xmlns="http://www.w3.org/2000/svg" width="${str width}" height="${str totalHeight}" viewBox="0 0 ${str width} ${str totalHeight}" font-family="ui-monospace, SFMono-Regular, Menlo, Consolas, monospace">
  <rect width="100%" height="100%" rx="10" fill="#${c.base00}"/>
  <text x="${str margin}" y="40" fill="#${c.base05}" font-size="20" font-weight="bold">${esc meta.name}</text>
  <text x="${str (width - margin)}" y="40" fill="#${c.base04}" font-size="13" text-anchor="end">${esc meta.variant} · by ${esc meta.author}</text>
  ${row 0 "base00–base07 · background to foreground" (lib.sublist 0 8 colorNames)}
  ${row 1 "base08–base0F · accents" (lib.sublist 8 8 colorNames)}
  ${row 2 "base10–base17 · Base24 extensions" (lib.sublist 16 8 colorNames)}
  <rect x="${str margin}" y="${str codeTop}" width="${str (width - 2 * margin)}" height="${str codeHeight}" rx="6" fill="#${c.base01}" stroke="#${c.base02}"/>
  ${lib.concatStrings (lib.imap0 line sample)}</svg>
''
