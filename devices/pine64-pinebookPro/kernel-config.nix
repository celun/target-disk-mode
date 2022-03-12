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
        AXP20X_ADC = yes;
        AXP20X_POWER = yes;
        AXP288_FUEL_GAUGE = yes;
        BATTERY_AXP20X = yes;
        BATTERY_BQ27XXX = yes;
        BATTERY_BQ27XXX_I2C = yes;
        BATTERY_CW2015 = yes;
        CHARGER_AXP20X = yes;
        CHARGER_GPIO = yes;
        IIO = yes;
        MFD_AXP20X = yes;
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
      })

      (with lib.kernel; {
        DRM_ROCKCHIP = yes;
        DRM_PANEL_SIMPLE = yes;
        DRM_PANFROST = yes;
        # Deps:
        DRM = yes;
        DRM_BRIDGE = yes;
        PHY_ROCKCHIP_DP = yes;
        PHY_ROCKCHIP_INNO_DSIDPHY = yes;
        PHY_ROCKCHIP_INNO_HDMI = yes;
        ROCKCHIP_ANALOGIX_DP = yes;
        ROCKCHIP_DW_HDMI = yes;
        ROCKCHIP_DW_MIPI_DSI = yes;
        ROCKCHIP_IOMMU = yes;

        # Transitive deps (forces it to be selected)
        DRM_ANALOGIX_DP = yes;
        DRM_DW_HDMI = yes;
        DRM_DW_MIPI_DSI = yes;
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
        BACKLIGHT_PWM = yes;
        # Deps:
        PWM = yes;
        PWM_ROCKCHIP = yes;
        BACKLIGHT_CLASS_DEVICE = yes;
      })

      # Power / regulators
      (with lib.kernel; {
        ROCKCHIP_IODOMAIN = yes;
        ROCKCHIP_PM_DOMAINS = yes;

        REGULATOR = yes;
        REGULATOR_FIXED_VOLTAGE = yes;
        REGULATOR_PWM = yes;
        REGULATOR_GPIO = yes;

        REGULATOR_AXP20X = yes;
        MFD_AXP20X_I2C = yes;
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
        MMC_SDHCI_OF_ARASAN = yes;

        # Undeclared dependency for mmc@fe320000
        I2C_RK3X = yes;
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

      # FIXME: add support for NVMe
      # (with lib.kernel; {
      #   PCIE_ROCKCHIP_HOST = yes;
      #   PHY_ROCKCHIP_PCIE = yes;
      #   # Deps:
      #   PCI = yes;
      #   ARCH_ROCKCHIP = yes;
      #   COMPILE_TEST = yes;

      #   # TODO: verify if needed
      #   PCIE_DW = yes;
      #   PCIE_DW_HOST = yes;
      #   PCIE_DW_PLAT = yes;
      #   PCIE_DW_PLAT_HOST = yes;
      # })
    ];
  };
}
