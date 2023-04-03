
{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Macchiato";
    font.size = 14;
    font.name = "Fira Code";
    # extraConfig = builtins.readFile ./kitty.conf;
  };
  
}