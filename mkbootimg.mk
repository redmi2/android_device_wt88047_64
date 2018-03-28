LOCAL_PATH := $(call my-dir)

## Build and run dtbtool
DTBTOOL := $(HOST_OUT_EXECUTABLES)/dtbToolCM$(HOST_EXECUTABLE_SUFFIX)
INSTALLED_DTIMAGE_TARGET := $(PRODUCT_OUT)/dt.img


possible_dtb_dirs = $(KERNEL_OUT)/arch/$(TARGET_KERNEL_ARCH)/boot/dts/ $(KERNEL_OUT)/arch/arm/boot/
dtb_dir = $(firstword $(wildcard $(possible_dtb_dirs)))

$(INSTALLED_DTIMAGE_TARGET): $(DTBTOOL) $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Target dt image: $(INSTALLED_DTIMAGE_TARGET)")
	$(hide) $(DTBTOOL) $(BOARD_DTBTOOL_ARGS) -o $(INSTALLED_DTIMAGE_TARGET) -s $(BOARD_KERNEL_PAGESIZE) -p $(KERNEL_OUT)/scripts/dtc/ $(KERNEL_OUT)/arch/$(KERNEL_ARCH)/boot/dts/
	@echo -e ${CL_CYN}"Made DT image: $@"${CL_RST}

## Overload bootimg generation: Same as the original, + --dt arg
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(INSTALLED_DTIMAGE_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTFS) $(TARGET_ROOT_OUT) | $(MINIGZIP) > $(INSTALLED_RAMDISK_TARGET)
	$(hide) $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_ARGS) --dt $(INSTALLED_DTIMAGE_TARGET) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE),raw)
	@echo -e ${CL_CYN}"Made boot image: $@"${CL_RST}

## Overload recoveryimg generation: Same as the original, + --dt arg
## Actually its the same as the original, no --dt arg's
define build-recoveryimage-target
  @echo ----- Making recovery image ------
  $(hide) mkdir -p $(TARGET_RECOVERY_OUT)
  $(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/etc $(TARGET_RECOVERY_ROOT_OUT)/sdcard $(TARGET_RECOVERY_ROOT_OUT)/tmp
  @echo Copying baseline ramdisk...
  # Use rsync because "cp -Rf" fails to overwrite broken symlinks on Mac.
  $(hide) rsync -a --exclude=etc --exclude=sdcard $(IGNORE_RECOVERY_SEPOLICY) $(IGNORE_CACHE_LINK) $(TARGET_ROOT_OUT) $(TARGET_RECOVERY_OUT)
  @echo Modifying ramdisk contents...
  $(if $(BOARD_RECOVERY_KERNEL_MODULES), \
    $(call build-image-kernel-modules,$(BOARD_RECOVERY_KERNEL_MODULES),$(TARGET_RECOVERY_ROOT_OUT),,$(call intermediates-dir-for,PACKAGING,depmod_recovery)))
  $(hide) rm -f $(TARGET_RECOVERY_ROOT_OUT)/init*.rc
  $(hide) cp -f $(recovery_initrc) $(TARGET_RECOVERY_ROOT_OUT)/
  $(hide) cp $(TARGET_ROOT_OUT)/init.recovery.*.rc $(TARGET_RECOVERY_ROOT_OUT)/ || true # Ignore error when the src file doesn't exist.
  $(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/res
  $(hide) rm -rf $(TARGET_RECOVERY_ROOT_OUT)/res/*
  $(hide) cp -rf $(recovery_resources_common)/* $(TARGET_RECOVERY_ROOT_OUT)/res
  $(hide) cp -f $(recovery_font) $(TARGET_RECOVERY_ROOT_OUT)/res/images/font.png
  $(hide) $(foreach item,$(TARGET_PRIVATE_RES_DIRS), \
    cp -rf $(item) $(TARGET_RECOVERY_ROOT_OUT)/$(newline))
  $(hide) $(foreach item,$(recovery_fstab), \
    cp -f $(item) $(TARGET_RECOVERY_ROOT_OUT)/etc/recovery.fstab)
  $(if $(strip $(recovery_wipe)), \
    $(hide) cp -f $(recovery_wipe) $(TARGET_RECOVERY_ROOT_OUT)/etc/recovery.wipe)
  $(hide) cp $(RECOVERY_INSTALL_OTA_KEYS) $(TARGET_RECOVERY_ROOT_OUT)/res/keys
  $(hide) cat $(INSTALLED_DEFAULT_PROP_TARGET) \
          > $(TARGET_RECOVERY_ROOT_OUT)/prop.default
  $(if $(INSTALLED_VENDOR_DEFAULT_PROP_TARGET), \
    $(hide) cat $(INSTALLED_VENDOR_DEFAULT_PROP_TARGET) \
            >> $(TARGET_RECOVERY_ROOT_OUT)/prop.default)
  $(hide) cat $(recovery_build_props) \
          >> $(TARGET_RECOVERY_ROOT_OUT)/prop.default
  $(hide) ln -sf prop.default $(TARGET_RECOVERY_ROOT_OUT)/default.prop
  $(BOARD_RECOVERY_IMAGE_PREPARE)
  $(if $(filter true,$(BOARD_BUILD_SYSTEM_ROOT_IMAGE)), \
    $(hide) mkdir -p $(TARGET_RECOVERY_ROOT_OUT)/system_root; \
            rm -rf $(TARGET_RECOVERY_ROOT_OUT)/system; \
            ln -sf /system_root/system $(TARGET_RECOVERY_ROOT_OUT)/system) # Mount the system_root_image to /system_root and symlink /system.
  $(hide) $(MKBOOTFS) -d $(TARGET_OUT) $(TARGET_RECOVERY_ROOT_OUT) | $(MINIGZIP) > $(recovery_ramdisk)
  $(if $(filter true,$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_VBOOT)), \
    $(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $(1).unsigned, \
    $(hide) $(MKBOOTIMG) $(INTERNAL_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $(1) --id > $(RECOVERYIMAGE_ID_FILE))
  $(if $(filter true,$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_BOOT_SIGNER)),\
    $(if $(filter true,$(BOARD_USES_RECOVERY_AS_BOOT)),\
      $(BOOT_SIGNER) /boot $(1) $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VERITY_SIGNING_KEY).pk8 $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VERITY_SIGNING_KEY).x509.pem $(1),\
      $(BOOT_SIGNER) /recovery $(1) $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VERITY_SIGNING_KEY).pk8 $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VERITY_SIGNING_KEY).x509.pem $(1)\
    )\
  )
  $(if $(filter true,$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_VBOOT)), \
    $(VBOOT_SIGNER) $(FUTILITY) $(1).unsigned $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VBOOT_SIGNING_KEY).vbpubk $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VBOOT_SIGNING_KEY).vbprivk $(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_VBOOT_SIGNING_SUBKEY).vbprivk $(1).keyblock $(1))
  $(if $(and $(filter true,$(BOARD_USES_RECOVERY_AS_BOOT)),$(filter true,$(BOARD_AVB_ENABLE))), \
      $(hide) $(AVBTOOL) add_hash_footer \
        --image $(1) \
        --partition_size $(BOARD_BOOTIMAGE_PARTITION_SIZE) \
        --partition_name boot $(INTERNAL_AVB_SIGNING_ARGS) \
        $(BOARD_AVB_BOOT_ADD_HASH_FOOTER_ARGS))
  $(if $(filter true,$(BOARD_USES_RECOVERY_AS_BOOT)), \
    $(hide) $(call assert-max-image-size,$(1),$(BOARD_BOOTIMAGE_PARTITION_SIZE)), \
    $(hide) $(call assert-max-image-size,$(1),$(BOARD_RECOVERYIMAGE_PARTITION_SIZE)))
  @echo ----- Made recovery image: $(1) --------
endef

ifeq ($(BOARD_USES_RECOVERY_AS_BOOT),true)
ifeq (true,$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_BOOT_SIGNER))
$(INSTALLED_BOOTIMAGE_TARGET) : $(BOOT_SIGNER)
endif
ifeq (true,$(PRODUCTS.$(INTERNAL_PRODUCT).PRODUCT_SUPPORTS_VBOOT))
$(INSTALLED_BOOTIMAGE_TARGET) : $(VBOOT_SIGNER)
endif
ifeq (true,$(BOARD_AVB_ENABLE))
$(INSTALLED_BOOTIMAGE_TARGET) : $(AVBTOOL)
endif
$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTFS) $(MKBOOTIMG) $(MINIGZIP) \
		$(INSTALLED_RAMDISK_TARGET) \
		$(INTERNAL_RECOVERYIMAGE_FILES) \
		$(recovery_initrc) $(recovery_sepolicy) $(recovery_kernel) \
		$(INSTALLED_2NDBOOTLOADER_TARGET) \
		$(recovery_build_props) $(recovery_resource_deps) \
		$(recovery_fstab) \
		$(RECOVERY_INSTALL_OTA_KEYS) \
		$(INSTALLED_VENDOR_DEFAULT_PROP_TARGET) \
		$(BOARD_RECOVERY_KERNEL_MODULES) \
		$(DEPMOD)
		$(call pretty,"Target boot image from recovery: $@")
		$(call build-recoveryimage-target, $@)
endif

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTFS) $(MKBOOTIMG) $(MINIGZIP) $(RECOVERYIMAGE_EXTRA_DEPS)\
		$(INSTALLED_RAMDISK_TARGET) \
		$(INSTALLED_BOOTIMAGE_TARGET) \
		$(INTERNAL_RECOVERYIMAGE_FILES) \
		$(recovery_initrc) $(recovery_sepolicy) $(recovery_kernel) \
		$(INSTALLED_2NDBOOTLOADER_TARGET) \
		$(recovery_build_props) $(recovery_resource_deps) \
		$(recovery_fstab) \
		$(RECOVERY_INSTALL_OTA_KEYS) \
		$(INSTALLED_VENDOR_DEFAULT_PROP_TARGET) \
		$(BOARD_RECOVERY_KERNEL_MODULES) \
		$(DEPMOD)
		$(call build-recoveryimage-target, $@)


