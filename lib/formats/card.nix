# Gallery card: a code sample on the theme's background, a strip of every
# palette color, and system/variant tags (after tinted-theming's gallery).
# The images in previews/cards/ are generated with this (see `cards`).
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
  sample = import ./sample.nix;

  # Base16 themes have their Base24 colors filled in by fallbacks.
  system = if builtins.all (name: theme ? ${name}) colorNames then "base24" else "base16";

  width = 392;
  pad = 16;
  inner = width - 2 * pad;

  lineHeight = 17;
  codeTop = pad + 14;
  line =
    i: segments:
    ''<text x="${str pad}" y="${str (codeTop + i * lineHeight)}" font-size="11" xml:space="preserve">''
    + lib.concatMapStrings (
      seg: ''<tspan fill="#${c.${builtins.elemAt seg 0}}">${esc (builtins.elemAt seg 1)}</tspan>''
    ) segments
    + "</text>\n";

  stripTop = codeTop + builtins.length sample * lineHeight + 8;
  stripHeight = 28;
  cell = inner / builtins.length colorNames;
  swatch =
    i: name:
    ''<rect x="${str (pad + i * cell)}" y="${str stripTop}" width="${str cell}" height="${str stripHeight}" fill="#${c.${name}}"><title>${name} #${
      c.${name}
    }</title></rect>
'';

  tagTop = stripTop + stripHeight + 14;
  tagHeight = 20;
  tag =
    x: label:
    let
      w = 16 + 7 * builtins.stringLength label;
    in
    {
      inherit w;
      svg = ''
        <rect x="${str x}" y="${str tagTop}" width="${str w}" height="${str tagHeight}" rx="10" fill="#${c.base01}" stroke="#${c.base02}"/>
        <text x="${str (x + w / 2)}" y="${str (tagTop + 14)}" fill="#${c.base04}" font-size="11" text-anchor="middle">${esc label}</text>
      '';
    };
  systemTag = tag pad system;
  variantTag = tag (pad + systemTag.w + 6) meta.variant;

  height = tagTop + tagHeight + pad;
in
''
  <svg xmlns="http://www.w3.org/2000/svg" width="${str width}" height="${str height}" viewBox="0 0 ${str width} ${str height}" font-family="ui-monospace, SFMono-Regular, Menlo, Consolas, monospace">
  <title>${esc meta.name}</title>
  <rect x="0.5" y="0.5" width="${str (width - 1)}" height="${str (height - 1)}" rx="10" fill="#${c.base00}" stroke="#${c.base02}"/>
  <clipPath id="strip"><rect x="${str pad}" y="${str stripTop}" width="${str inner}" height="${str stripHeight}" rx="4"/></clipPath>
  ${lib.concatStrings (lib.imap0 line sample)}<g clip-path="url(#strip)">
  ${lib.concatStrings (lib.imap0 swatch colorNames)}</g>
  <rect x="${str pad}" y="${str stripTop}" width="${str inner}" height="${str stripHeight}" rx="4" fill="none" stroke="#${c.base02}"/>
  ${systemTag.svg}${variantTag.svg}</svg>
''
