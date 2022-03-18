{ config, lib, pkgs, ... }:

{
  imports = [
    ./minify.nix
    ./kernel-config.nix
  ];

  device = {
    name = "valve/jupiter";
  };

  hardware = {
    cpu = "generic-x86_64";
    #cpu = "amd-vangogh";
  };

  wip.uefi.enable = true;

  wip.kernel.package = pkgs.callPackage ./kernel {};
  wip.kernel.defconfig = pkgs.writeText "empty" "";

  boot.cmdline = [
    "drm.vblankoffdelay=1"
    "vt.global_cursor_default=0"
    "console=tty2"
    "loglevel=0"
    "fbcon=rotate:1"
  ];
}
