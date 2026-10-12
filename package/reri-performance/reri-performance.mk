################################################################################
# RERI performance monitor
################################################################################

RERI_PERFORMANCE_VERSION = 766dcdc01bf7344a6c93ed3f245a7790408a82f3
RERI_PERFORMANCE_SITE = https://github.com/ertento/reri-performance.git
RERI_PERFORMANCE_SITE_METHOD = git
RERI_PERFORMANCE_DEPENDENCIES = python3 reri-papi

define RERI_PERFORMANCE_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) \
		-I$(STAGING_DIR)/usr/include \
		-L$(STAGING_DIR)/usr/lib \
		-o $(@D)/reri-papi-sampler $(@D)/reri_papi_sampler.c -lpapi
endef

define RERI_PERFORMANCE_INSTALL_TARGET_CMDS
	$(INSTALL) -d $(TARGET_DIR)/opt/reri_monitor_performance
	cp -a $(@D)/app $(TARGET_DIR)/opt/reri_monitor_performance/
	$(INSTALL) -D -m 0755 $(@D)/reri-papi-sampler \
		$(TARGET_DIR)/usr/bin/reri-papi-sampler
endef

$(eval $(generic-package))
