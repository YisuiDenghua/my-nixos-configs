{ config, pkgs, lib, ... }:

{
  home.username = "yisui";
  home.homeDirectory = "/home/yisui";
  
  home.stateVersion = "22.05";


  programs.home-manager.enable = true;
}

