{
  name = "Birdland";
  author = "chrisppy";
  variant = "dark";
  # Baltimore Orioles:
  #   Primary: Orioles orange #df4601 / black
  #   2023 City Connect: black / grayscale exterior
  #   2026 City Connect: cream / Camden green / orange (warehouse brick trim)
  # Every accent from base08 to base0F reaches at least 4.5:1 contrast on base00.

  base00 = "0b0b0b"; # Black — primary background
  base01 = "151515"; # Black — panels / secondary background
  base02 = "292929"; # Dark gray — selection / highlighted background
  base03 = "464646"; # Gray — comments / inactive elements
  base04 = "8a8a8a"; # Gray — muted foreground
  base05 = "e5dfd2"; # Cream — primary foreground / 2026 City Connect
  base06 = "f2eee5"; # Warm white — bright foreground
  base07 = "fffdf8"; # White — maximum contrast
  base08 = "df4601"; # Orioles orange (official) — variables / errors
  base09 = "ff7a1a"; # Bright orange — numbers / constants
  base0A = "d4ad4c"; # Brass — classes / warnings / Eutaw Street plaques
  base0B = "4f8f6a"; # Camden Yards seat green — strings / success
  base0C = "86b8a4"; # Pale Camden green — support / escapes (cyan slot)
  base0D = "d98b45"; # Warehouse orange — functions / links (blue slot)
  base0E = "b8683f"; # Baltimore brick — keywords (magenta slot)
  base0F = "b8b0a3"; # Warm gray — deprecated / embedded

  # Base24 extensions
  base10 = "070707"; # Darker background — must not be lighter than base00
  base11 = "030303"; # Darkest background — must not be lighter than base10
  base12 = "ff5a00"; # Bright red — bright Orioles orange
  base13 = "ebc770"; # Bright yellow — bright brass
  base14 = "6cad86"; # Bright green — bright Camden green
  base15 = "a6d3c1"; # Bright cyan — bright pale green
  base16 = "f0a764"; # Bright blue — bright warehouse orange
  base17 = "d6875c"; # Bright magenta — bright brick
}
