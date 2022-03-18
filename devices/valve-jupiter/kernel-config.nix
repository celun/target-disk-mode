{ lib, ... }:

{
  wip.kernel = {
    structuredConfig = lib.mkMerge [
      (with lib.kernel; {
        SPI_AMD = yes; /* deps: */ SPI = yes;
        PINCTRL_AMD = yes; /* deps: */ PINCTRL = yes;
      })
      (with lib.kernel; {
        JUPITER = yes;
        /* deps: */
        REGMAP = yes;
        I2C_DESIGNWARE_PLATFORM = yes; /* deps: */ I2C = yes;
      })
      (with lib.kernel; {
        FB_EFI = yes;
        BACKLIGHT_CLASS_DEVICE = yes;
        FRAMEBUFFER_CONSOLE_ROTATION = yes;
        FRAMEBUFFER_CONSOLE_DETECT_PRIMARY = yes;
      })
      # TODO: Somehow make configurable
      # (with lib.kernel; {
      #   LTRF216A = yes; /* deps: */ IIO = yes; I2C = yes;
      # })
      # TODO: allow introspecting current config to `mkIf SND != no`
      # (with lib.kernel; {
      #   SND_SOC_CS35L41 = yes;
      #   SND_SOC_CS35L41_SPI = yes;

      #   SND_SOC_AMD_ACP5x = yes;
      #   SND_SOC_AMD_VANGOGH_MACH = yes;
      #   SND_SOC_WM_ADSP = yes;
      #   # CONFIG_SND_SOC_CS35L41_I2C is not set
      #   SND_SOC_NAU8821 = yes;
      #   # Doesn't build on latest tag, not used in neptune hardware (?)
      #   SND_SOC_CS35L36 = no;
      # })

      (with lib.kernel; {
        # SD card reader
        MMC = lib.mkForce yes;

        # Internal storage
        BLK_DEV_NVME = yes; /* deps: */ PCI = yes;

        # USB interface
        USB = yes;
        USB_DWC3 = yes;
        #USB_DWC3_GADGET = yes;
        USB_DWC3_HOST = no;
        USB_DWC3_DUAL_ROLE = yes;
        NOP_USB_XCEIV = yes;
        USB_PHY = yes;

        # Keyboard input
        USB_HIDDEV = yes;
        HID_PID = yes;
        USB_XHCI_HCD = yes;

        TYPEC = yes;
        TYPEC_TCPM = yes;

        #TYPEC_FUSB302 = yes;
        #I2C = yes;

        PCIEPORTBUS = yes;
        HOTPLUG_PCI_PCIE = yes;
        PCI_MSI = yes;
        HOTPLUG_PCI = yes;
        HOTPLUG_PCI_ACPI = yes;
        ACPI_PCI_SLOT = yes;

        # Unlikely:
        PCIE_DW = yes;
        PCIE_DW_HOST = yes;
        PCIE_DW_PLAT = yes;
        PCIE_DW_PLAT_HOST = yes;
      })
    ];
  };
}
