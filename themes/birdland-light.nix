{
  name = "Birdland Light";
  author = "chrisppy";
  variant = "light";
  # The light counterpart of Birdland: the 2026 City Connect cream as the
  # background, with the same Orioles accents deepened for a light surface.
  # Every accent from base08 to base0F reaches at least 4.5:1 contrast on
  # base00 and base01.

  base00 = "f4efe4"; # Cream — primary background / 2026 City Connect
  base01 = "ebe5d8"; # Darker cream — panels / secondary background
  base02 = "ddd5c5"; # Tan — selection / highlighted background
  base03 = "a39c90"; # Warm gray — comments / inactive elements
  base04 = "6b665e"; # Dark warm gray — muted foreground
  base05 = "26231f"; # Charcoal — primary foreground
  base06 = "151413"; # Near black — bright foreground
  base07 = "0b0b0b"; # Black — maximum contrast / 2023 City Connect
  base08 = "b83c00"; # Deep Orioles orange — variables / errors
  base09 = "9a5000"; # Amber orange — numbers / constants
  base0A = "7a611d"; # Brass — classes / warnings / Eutaw Street plaques
  base0B = "3b7048"; # Camden Yards seat green — strings / success
  base0C = "356a63"; # Deep pale Camden green — support / escapes (cyan slot)
  base0D = "7f5530"; # Warehouse brown — functions / links (blue slot)
  base0E = "9b4a2e"; # Baltimore brick — keywords (magenta slot)
  base0F = "6d6455"; # Warm gray — deprecated / embedded

  # Base24 extensions. The "darker" backgrounds are darker cream, so the
  # depth order (base11 <= base10 <= base00) holds as in every bundled theme.
  base10 = "efe9dd"; # Darker background
  base11 = "e9e3d6"; # Darkest background
  base12 = "a83300"; # Bright red — intense Orioles orange
  base13 = "6b5410"; # Bright yellow — intense brass
  base14 = "2e6140"; # Bright green — intense Camden green
  base15 = "2c5d57"; # Bright cyan — intense pale green
  base16 = "6c4626"; # Bright blue — intense warehouse brown
  base17 = "8a3f24"; # Bright magenta — intense brick
}
