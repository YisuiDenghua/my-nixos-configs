{ pkgs, ... }：
let
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
  environment.systemPackages = [ chroot-sarbbm ];
}
