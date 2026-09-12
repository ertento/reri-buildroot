################################################################################
# RERI standard kernel/GHES monitor
################################################################################

RERI_MONITOR_STANDARD_VERSION = 4f9556506a19d0c4c7122a80f5a6f9a866aa2e6e
RERI_MONITOR_STANDARD_SITE = https://github.com/ertento/reri-monitor-standard.git
RERI_MONITOR_STANDARD_SITE_METHOD = git
RERI_MONITOR_STANDARD_DEPENDENCIES = python3

define RERI_MONITOR_STANDARD_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/opt/reri_monitor_standard
	cp -a $(@D)/app $(TARGET_DIR)/opt/reri_monitor_standard/
endef

$(eval $(generic-package))
