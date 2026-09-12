################################################################################
# RERI laboratory monitor
################################################################################

RERI_MONITOR_VERSION = c0133f765e73f5270b9462d316bae6811340ac39
RERI_MONITOR_SITE = https://github.com/ertento/reri-monitor.git
RERI_MONITOR_SITE_METHOD = git
RERI_MONITOR_DEPENDENCIES = python3

define RERI_MONITOR_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/opt/reri-monitor
	cp -a $(@D)/app $(TARGET_DIR)/opt/reri-monitor/
endef

$(eval $(generic-package))
