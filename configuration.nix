# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, options,  ... }:

let

 

  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';

  chroot-sarbbm = pkgs.writeShellScriptBin "chroot-sarbbm"''
    mkdir -p "$@"/nix
    mkdir -p "$@"/run/binfmt
    mount --bind /run/binfmt "$@"/run/binfmt
    mount --bind /nix "$@"/nix
    chroot "$@" /bin/bash -l
    umount "$@"/run/binfmt
    umount "$@"/nix
    rm -r "$@"/nix
    rm -r "$@"/run/binfmt 
  '';


in


{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./vim.nix
      # ./mc/server.nix
      # ./chroot-sarbbm
    ];

  nixpkgs.overlays = [
    # (import ./fr.nix)
  ];
    

  programs.fish.enable = true;
  boot.tmpOnTmpfs = true;

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "button.lid_init_state=open"
    "i915.enable_psr=0"
    "ibt=off"
  ];
  # RISC-V
  boot.binfmt.emulatedSystems = [
    "riscv64-linux"
  ];
  boot.extraModprobeConfig = "options kvm_intel nested=1";
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;


  # Enable Flakes
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings.auto-optimise-store = true; # auto garbage clean
  };


  
  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelPackages = pkgs.linuxPackages_zen;

  
  # GRUB

  boot.plymouth = { 
    enable = true;
    
  };
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/efi";
    grub = {
      enable = true;
      device = "nodev";
      theme = pkgs.nixos-grub2-theme;
      #theme = pkgs.libsForQt5.breeze-grub;
      # default = "1";
      efiSupport = true;
      extraEntries = ''
        menuentry "Windows" {
          search --file --no-floppy --set=root /EFI/Microsoft/Boot/bootmgfw.efi
          chainloader (''${root})/EFI/Microsoft/Boot/bootmgfw.efi
        }
      '';
    };
  };

  networking.hostName = "legion-y9000x"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable v2rayA
  services.v2raya.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-rime fcitx5-chinese-addons fcitx5-table-extra fcitx5-gtk libsForQt5.fcitx5-qt ];
    ibus.engines = with pkgs.ibus-engines; [ rime ];
  };
 
  # environment.variables = {
  #   GTK_IM_MODULE = "fcitx";
  #   QT_IM_MODULE = "fcitx";
  #   XMODIFIERS = "@im=fcitx";
  #   INPUT_METHOD = "fcitx";
  #   SDL_IM_MODULE = "fcitx";
  #   GLFW_IM_MODULE = "ibus";
  #   NIX_RIME_DATA = "/run/current-system/sw/share/rime-data"; 
  # };
 
  systemd.user.services.fcitx5-daemon.environment = {
    NIX_RIME_DATA = "/run/current-system/sw/share/rime-data";
  };

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };


  # services.xserver.autorun = false;
  # Enable the X11 windowing system.
  services.xserver.enable = true;
 
  
  nixpkgs.config.allowUnfree = true;


  # fonts.fontDir.enable = true;
  fonts = {
    fonts = with pkgs; [
      fira-mono
      roboto
      work-sans
      comic-neue
      source-sans
      twemoji-color-font
      comfortaa
      inter
      lato
      dejavu_fonts
      iosevka-bin
      noto-fonts
      noto-fonts-cjk
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      jetbrains-mono
      sarasa-gothic
      source-han-sans
    
      (nerdfonts.override { fonts = [ "FiraMono" "Iosevka" ]; })
    ];

    # enableDefaultFonts = false;

    fontconfig = {
      defaultFonts = {
        monospace = [
          "Fira Mono"
          # "Hack"
          # "Iosevka"
          # "Iosevka Term"
          # "Iosevka Term Nerd Font Complete Mono"
          # "Iosevka Nerd Font"
          "Noto Color Emoji"
        ];
        sansSerif = [ "Source Han Sans"  ];
        serif = [ "Noto Serif CJK SC"  ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };


  # Enable NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.opengl.enable = true;
  hardware.opengl = {
    enable = true;
    mesaPackage = pkgs.mesa;
    extraPackages = with pkgs; [
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
    ];
  };  

  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
 
  
  

 
  hardware.nvidia.open = false;
  hardware.nvidia.modesetting.enable = true;

  # Enable Steam
  programs.steam.enable = true;
  
  # Enable flatpak
  services.flatpak.enable = true;
  # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable Bluetooth
  hardware.bluetooth.enable = true;

  # Enable Virtualbox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "yisui" ];
 
  
  # virtualisation.virtualbox.host.enableExtensionPack = true;

  hardware.firmware = [ pkgs.sof-firmware ];
  

 

  environment.etc."greetd/environments".text = ''
    sway
    fish
    bash
    startxfce4
  '';

  services.xserver.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  services.xserver.dpi = 144;
  
  services.xserver.desktopManager.plasma5.enable = false;
  services.xserver.windowManager.openbox.enable = true;

  services.xserver.desktopManager.gnome = {
    enable = true;
    flashback.enableMetacity = false;
    # extraGSettingsOverridePackages = [ pkgs.gnome-desktop ];
    
    extraGSettingsOverridePackages = [ pkgs.gnome.mutter ];
    extraGSettingsOverrides = ''
      [org.gnome.mutter]
      # experimental-features=['x11-randr-fractional-scaling']
      experimental-features=['scale-monitor-framebuffer']
    '';
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = {
  #   "eurosign:e";
  #   "caps:escape" # map caps to escape.
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  # };
  

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yisui = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "libvirtd" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      # firefox
  #     thunderbird
    ];
  };

  # Enable Yubikey
  services.udev.packages = [ pkgs.yubikey-personalization 
    pkgs.gnome.gnome-settings-daemon
  ];
  


  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    lxappearance
    flameshot
    ocs-url 
    firefox
    vulkan-tools
    glxinfo
    nvidia-offload
    libsForQt5.sddm-kcm 
    tdesktop  
    (chromium.override {
      commandLineArgs = [
        # "--gtk-version=4"
        "--enable-wayland-ime"
      ];
    })
 
    (google-chrome.override {
      commandLineArgs = [
        # "--gtk-version=4"
        "--enable-wayland-ime"
      ];
    })

    
    libsForQt5.ark
    hyfetch
    yakuake 
    libsForQt5.kate
    git
    github-cli
    networkmanagerapplet
    vscode-fhs
    vscodium-fhs
    video-trimmer
    virt-manager
    neofetch
    libsForQt5.kdenlive
    krita
    mpv
    vlc
     
    linphone
    openvpn 
    papirus-folders
    gimp
    papirus-icon-theme
    libsForQt5.qtstyleplugin-kvantum
    gnome.gnome-terminal
    gnome.gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnome.gedit
    unrar
    virtualenv
    python310
    aria2
    kleopatra
    blackbox-terminal
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.dash-to-panel
    pfetch
    whitesur-icon-theme
    whitesur-gtk-theme
    
    gnomeExtensions.logo-menu
    netease-cloud-music-gtk
    gparted
    obs-studio
    distrobox
    xorg.xhost
    xorg.xinit
    wineWowPackages.stagingFull 
    adw-gtk3
    # winetricks (all versions)
    winetricks

    # native wayland support (unstable)
    
    uwufetch
    orchis-theme
    materia-theme
    material-icons
    material-design-icons
    termius
    gnomeExtensions.arcmenu
    tela-icon-theme
    numix-icon-theme-circle
    gnomeExtensions.runcat
    gnomeExtensions.material-you-color-theming
    gnome.gnome-notes
    gnome.gnome-mines
    gnome.gnome-screenshot
    libreoffice-qt
    go
    go-task
    gnomeExtensions.transparent-shell
    numix-icon-theme-circle
    gnomeExtensions.transparent-top-bar
    gnomeExtensions.blur-my-shell
    nodePackages.sass
    nodejs
    
    wl-color-picker
    lutris
    proton-caller
    microsoft-edge
    gnomeExtensions.logo-menu
    icu 
    chroot-sarbbm
    lmms
    gamemode
    xdelta
    prismlauncher
    jdk17
    tilix
    gnomeExtensions.x11-gestures
    # genymotion
    # yubikey-manager
    # yubikey-manager-qt
    qq
    libsForQt5.krecorder
    gnome.gnome-sound-recorder
    lunar-client 
    clash-meta
    clash-verge
    clash
    proxychains-ng
    adapta-gtk-theme 
    (emacs.override { withPgtk = true; })
    gcc
    android-tools
    kitty
    glfw-wayland 
    motrix
    weston
    p7zip
    plata-theme
    helix
    steam-run
    libsForQt5.oxygen-icons5
    libsForQt5.oxygen
    libsForQt5.oxygen-sounds
    catppuccin-kde
    (pkgs.catppuccin-gtk.override {
      accents = [ "pink" ]; # You can specify multiple accents here to output multiple themes 
      size = "standard";
      # tweaks = [ "normal" ]; # You can also specify multiple tweaks here
      variant = "macchiato";
    })
    catppuccin-cursors
    catppuccin-papirus-folders
    gnome.gnome-themes-extra
    gtk-engine-murrine  
  ];

  virtualisation = {
    waydroid.enable = true;
    lxd.enable = true;
  };
  

  services.touchegg.enable = true;
  

  networking.extraHosts = 
    ''
      0.0.0.0 public-data-api.mihoyo.com
      0.0.0.0 log-upload.mihoyo.com
      0.0.0.0 uspider.yuanshen.com
      0.0.0.0 log-upload-os.mihoyo.com
      0.0.0.0 overseauspider.yuanshen.com
      0.0.0.0 log-upload.mihoyo.com
      0.0.0.0 uspider.yuanshen.com
      #如果怕封号，下面几行也可以加入，但会让你没法使用 Unity 编辑器
      0.0.0.0 prd-lender.cdp.internal.unity3d.com
      0.0.0.0 thind-prd-knob.data.ie.unity3d.com
      0.0.0.0 thind-gke-usc.prd.data.corp.unity3d.com
      0.0.0.0 cdp.cloud.unity3d.com
      0.0.0.0 remote-config-proxy-prd.uca.cloud.unity3d.com

    '';

 
 

  # TLP
  services.tlp.enable = true;
  services.power-profiles-daemon.enable = false; # gnome conflicts with tlp
  #services.tlp.settings = {
  #  CPU_SCALING_GOVERNOR_ON_AC = "powersave";
  #  CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
  #  CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
  #  CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
  #  CPU_BOOST_ON_AC = "1";
  #  CPU_BOOST_ON_BAT = "0";
  #  SCHED_POWERSAVE_ON_AC = "0";
  #  SCHED_POWERSAVE_ON_BAT = "1";
  #};


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  programs.seahorse.enable = false;


  #nix.settings.substituters = pkgs.lib.mkForce [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  #ix.settings.trusted-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" "https://cache.nixos.org" ];



  # nix.settings.substituters = pkgs.lib.mkForce [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  # nix.settings.trusted-substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" "https://cache.nixos.org" ];

  # Enable Docker
  virtualisation.docker.enable = true;
  


  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

