{ config, lib, pkgs, ... }:

{
  imports = [
    ./kernel-config.nix
  ];
  device = {
    name = "pine64/pinephone-pro";
    dtbFiles = [
      "rockchip/rk3399-pinephone-pro.dtb"
    ];
  };

  hardware = {
    cpu = "rockchip-rk3399";
  };

  boot.cmdline = [
    "console=ttyS2,115200n8"
    "earlycon=uart8250,mmio32,0xff1a0000"
  ];
}
