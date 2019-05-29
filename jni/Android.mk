LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE := retro

_retro_intermediates := $(call intermediates-dir-for,$(LOCAL_MODULE_CLASS),$(LOCAL_MODULE))

LOCAL_BUILT_MODULE_STEM := mame_libretro_android.so
_retro_so := $(_retro_intermediates)/$(LOCAL_BUILT_MODULE_STEM)

$(_retro_so): PRIVATE_CUSTOM_TOOL_ARGS := \
	TOOLCHAIN_PREFIX=$(abspath $(TARGET_TOOLS_PREFIX))
$(_retro_so): PRIVATE_CUSTOM_TOOL_ARGS += \
		BUILDROOT=$(_retro_intermediates) \
		TARGET=mame \
		RETRO=1 \
		OSD=retro \
		CONFIG=libretro \
		NOWERROR=1 \
		NOASM=1 \
		NO_USE_MIDI=1 \
		ANDROID_NDK_ROOT=$(NDK_ROOT) \
		ANDROID_NDK_LLVM=$(NDK_ROOT)/toolchains/llvm/prebuilt/linux-x86_64 \
		ANDROID_NDK_ARM=$(NDK_ROOT)/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64 \
		-C $(LOCAL_PATH)/.. \
		-f Makefile.libretro
$(_retro_so): PRIVATE_MODULE := $(LOCAL_MODULE)

.PHONY: $(_retro_so)
$(_retro_so):
	@mkdir -p $(dir $@)
	make $(PRIVATE_CUSTOM_TOOL_ARGS)

$(LOCAL_PATH)/dummy.cpp: $(_retro_so)
	touch $@

LOCAL_SRC_FILES := dummy.cpp
include $(BUILD_SHARED_LIBRARY)

# Clean variables
_retro_intermediates :=
_retro_so :=
