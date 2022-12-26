{ config, lib, pkgs, ... }:

{
  imports = [
    ./kernel-config.nix
  ];
  device = {
    name = "pine64/pinebook-pro";
    dtbFiles = [
      "rockchip/rk3399-pinebook-pro.dtb"
    ];
  };

  hardware = {
    cpu = "rockchip-rk3399";
  };

  wip.uefi.enable = true;
  # Required for dual-role fixup.
  wip.uefi.bundleDTB = true;

  boot.cmdline = [
    "console=ttyS2,115200n8"
    "earlycon=uart8250,mmio32,0xff1a0000"
  ];
}
