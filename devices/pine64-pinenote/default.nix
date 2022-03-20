{ config, lib, pkgs, ... }:

{
  imports = [
    ./firmware.nix
    ./kernel-config.nix
  ];

  target-disk-mode = {
    eink = true;
  };

  device = {
    name = "pine64/pinenote";
    dtbFiles = [
      "rockchip/rk3566-pinenote.dtb"
    ];
  };

  hardware = {
    cpu = "rockchip-rk3566";
  };

  boot.cmdline = [
    "console=ttyS2,115200n8"
    "earlycon=uart8250,mmio32,0xfe660000"
    "fbcon=rotate:1"
  ];
}
