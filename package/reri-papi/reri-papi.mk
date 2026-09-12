################################################################################
# PAPI with RISC-V SBI PMU support
################################################################################

RERI_PAPI_VERSION = 53b70fc3b6a76deb1c9e6bd1bf42a179347c5b1b
RERI_PAPI_SITE = https://github.com/ertento/reri-papi.git
RERI_PAPI_SITE_METHOD = git
RERI_PAPI_INSTALL_STAGING = YES

define RERI_PAPI_CONFIGURE_CMDS
	(cd $(@D)/src && rm -f config.cache && \
		$(TARGET_CONFIGURE_OPTS) ./configure \
		--build=$(GNU_HOST_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--prefix=/usr \
		--libdir=/usr/lib \
		--with-arch=riscv64 \
		--with-CPU=riscv64 \
		--with-OS=linux \
		--with-ffsll=yes \
		--with-walltimer=clock_realtime \
		--with-tls=__thread \
		--with-virtualtimer=clock_thread_cputime_id \
		--with-tests=no \
		--disable-perf-event-uncore \
		--with-sysdetect=no \
		--with-shared-lib=yes \
		--with-static-lib=no)
endef

define RERI_PAPI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src
endef

define RERI_PAPI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src DESTDIR=$(STAGING_DIR) install
endef

define RERI_PAPI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)/src DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
