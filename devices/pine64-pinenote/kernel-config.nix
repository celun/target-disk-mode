{ lib, pkgs, ... }:

{
  wip.kernel.package = pkgs.callPackage ./kernel {};
  wip.kernel.defconfig = pkgs.writeText "empty" "";

  wip.kernel = {
    structuredConfig = lib.mkMerge [
      (with lib.kernel; {
        ARCH_ROCKCHIP = yes;
        NR_CPUS = freeform "6";
        ARM_RK3399_DMC_DEVFREQ = yes;
      })

      (with lib.kernel; {
        CHARGER_GPIO = yes;
        CHARGER_RK817 = yes;
        IIO = yes;
      })

      (with lib.kernel; {
        EXTCON_USB_GPIO = yes;
        PHY_ROCKCHIP_INNO_USB2 = yes;
        PHY_ROCKCHIP_TYPEC = yes;
        PHY_ROCKCHIP_USB = yes;
        TYPEC = yes;
        TYPEC_FUSB302 = yes;
        TYPEC_TCPM = yes;
        USB_DWC3 = yes;
        USB_DWC3_OF_SIMPLE = yes; # ?
        USB_SNP_UDC_PLAT = yes; # ?
        USB_BDC_UDC = yes; # ?
        TYPEC_WUSB3801 = yes; # ?
      })

      (with lib.kernel; {
        DRM_PANFROST = yes;
        DRM = yes;
        ROCKCHIP_IOMMU = yes;
        DRM_ROCKCHIP_EBC = yes;

        # eink PMIC
        REGULATOR_TPS65185 = yes;

        # To rotate it at a more natural angle.
        FRAMEBUFFER_CONSOLE_ROTATION = yes;
      })

      (with lib.kernel; {
        ROCKCHIP_SARADC = yes;
        # Deps:
        IIO = yes;
      })

      # RTC
      (with lib.kernel; {
        RTC_DRV_RK808 = yes;
        # Deps:
        RTC_CLASS = yes;
        MFD_RK808 = yes;
      })

      # Backlight
      (with lib.kernel; {
        BACKLIGHT_LM3630A = yes;
        # Deps:
        BACKLIGHT_CLASS_DEVICE = yes;
      })

      # Power / regulators
      (with lib.kernel; {
        ROCKCHIP_IODOMAIN = yes;
        ROCKCHIP_PM_DOMAINS = yes;

        REGULATOR = yes;
        REGULATOR_FIXED_VOLTAGE = yes;
        PWM_ROCKCHIP = yes;
        PWM = yes;

        REGULATOR_FAN53555 = yes;
        REGULATOR_RK808 = yes;

        RC_CORE = yes;
        RC_MAP = yes;
        RC_DECODERS = yes;
        RC_DEVICES = yes;
      })

      # eMMC / SD
      (with lib.kernel; {
        MMC = yes;
        MMC_BLOCK = yes;

        PHY_ROCKCHIP_EMMC = yes;
        MMC_DW_ROCKCHIP = yes;
        MMC_DW = yes;
        MMC_SDHCI = yes;
        MMC_SDHCI_PLTFM = yes;
        MMC_SDHCI_OF_DWCMSHC = yes;
        MMC_SDHCI_F_SDH30 = yes;
        MMC_HSQ = yes;
        MMC_CQHCI = yes;

        # Undeclared dependency for [...]
        I2C_RK3X = yes; #?
        I2C_SLAVE = yes; #?
        I2C_DESIGNWARE_PLATFORM = yes; #?
      })

      # TODO: move DMA_CMA in a generic location
      (with lib.kernel; {
        CMA = yes;
        DMA_CMA = yes;
        DMADEVICES = yes;
      })

      # TODO: review if/how it is needed
      # TODO: make generic
      (with lib.kernel; {
        ARM_CPUIDLE = yes;
        ARM_SCPI_CPUFREQ = yes;
        CPUFREQ_DT = yes;
        CPUFREQ_DT_PLATDEV = yes;
        CPU_IDLE = yes;
        CPU_IDLE_GOV_LADDER = yes;
        CPU_IDLE_MULTIPLE_DRIVERS = yes;
        DT_IDLE_STATES = yes;
        CPU_FREQ = yes;
        CPU_FREQ_GOV_ATTR_SET = yes;
        CPU_FREQ_GOV_COMMON = yes;
        CPU_FREQ_STAT = yes;
        CPU_FREQ_DEFAULT_GOV_ONDEMAND = yes;
        CPU_FREQ_GOV_CONSERVATIVE = yes;
        CPU_FREQ_GOV_ONDEMAND = yes;
        CPU_FREQ_GOV_PERFORMANCE = yes;
        CPU_FREQ_GOV_POWERSAVE = yes;
        CPU_FREQ_GOV_SCHEDUTIL = yes;
        CPU_FREQ_GOV_USERSPACE = yes;

        COMMON_CLK_SCPI = yes;
        ARM_SCPI_PROTOCOL = yes;
        MAILBOX = yes;
        ROCKCHIP_MBOX = yes;
      })

      # # SPI Flash support
      # (with lib.kernel; {
      #   SPI = yes;
      #   SPI_ROCKCHIP = yes;
      #   MTD = yes;
      #   MTD_SPI_NOR = yes;
      #   MTD_BLOCK = yes;
      # })

      # Input
      (with lib.kernel; {
        # Touch screen
        INPUT_TOUCHSCREEN = yes;
        TOUCHSCREEN_CYTTSP4_CORE = yes;
        TOUCHSCREEN_CYTTSP4_I2C = yes;
        TOUCHSCREEN_CYTTSP5 = yes;

        # Power key
        INPUT_RK805_PWRKEY = yes;
        INPUT_MISC = yes;
      })
    ];
  };
}
