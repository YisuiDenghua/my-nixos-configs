

{
  pkgs,
  lib,
  config,
  # inputs,
  ...
}:
with lib; let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
  ocr = pkgs.writeShellScriptBin "ocr" ''
    #!/bin/bash
    grim -g "$(slurp -w 0 -b eebebed2)" /tmp/ocr.png && tesseract /tmp/ocr.png /tmp/ocr-output && wl-copy < /tmp/ocr-output.txt && notify-send "OCR" "Text copied!" && rm /tmp/ocr-output.txt -f
  '';
  screenshot = pkgs.writeShellScriptBin "screenshot" ''
    #!/bin/bash
    hyprctl keyword animation "fadeOut,0,8,slow" && ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp -w 0 -b 5e81acd2)" - | swappy -f -; hyprctl keyword animation "fadeOut,1,8,slow"
  '';
in {
  home.packages = with pkgs; [
    swaybg #Wallpaper
    kitty #Terminal
    waybar  #Status Bar
    libnotify 
    wf-recorder 
    brightnessctl #Brightness control
    pamixer #Sound control
    python39Packages.requests
    slurp
    tesseract5
    swappy
    ocr
    grim #Screenshot
    screenshot
    wl-clipboard
    pngquant
    kanshi
  ];

  

  wayland.windowManager.hyprland = {
    enable = true;
    # package = inputs.hyprland.packages.${pkgs.system}.default.override {
      # nvidiaPatches = true;
      # wlroots =
      #   inputs.hyprland.packages.${pkgs.system}.wlroots-hyprland.overrideAttrs
      #   (old: {
      #     patches =
      #       (old.patches or [])
      #       ++ [
      #         (pkgs.fetchpatch {
      #           url = "https://aur.archlinux.org/cgit/aur.git/plain/0001-nvidia-format-workaround.patch?h=hyprland-nvidia-screenshare-git";
      #           sha256 = "A9f1p5EW++mGCaNq8w7ZJfeWmvTfUm4iO+1KDcnqYX8=";
      #         })
      #       ];
      #   });
    # };
    systemdIntegration = true;
    xwayland = {
      enable = true;
      hidpi = true;
    };
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  services.wlsunset = {
    enable = false;
    latitude = "52.0";
    longitude = "21.0";
    temperature = {
      day = 6200;
      night = 3750;
    };
  };
  # systemd.user.services = {
    # swaybg = mkService {
      # Unit.Description = "Wallpaper chooser";
      # service = {
        # ExecStart = "${pkgs.swaybg}/bin/swaybg -i ${./wall.png}";
        # Restart = "always";
      # };
    # };
  # };
}
