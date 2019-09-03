#
# Arm SCP/MCP Software
# Copyright (c) 2015-2019, Arm Limited and Contributors. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#

ifndef BS_CPU_MK
BS_CPU_MK := 1

include $(BS_DIR)/defs.mk

BS_ARCH_CPU := $(BS_FIRMWARE_CPU)

# Supported ARMv7-M CPUs
ARMV7M_CPUS := cortex-m3 cortex-m4 cortex-m7

# for cortex-m4
#-mthumb -mapcs -std=gnu99 -mcpu=cortex-m4 -mfloat-abi=hard -mfpu=fpv4-sp-d16

ifneq ($(findstring $(BS_FIRMWARE_CPU),$(ARMV7M_CPUS)),)
    BS_ARCH_ISA := thumb

	ifneq ($(BS_VENDOR_SPECS),)
    	LDFLAGS_GCC += --specs=$(BS_VENDOR_SPECS)
	else
    	LDFLAGS_GCC += --specs=nano.specs
	endif

	LDFLAGS_ARM += --target=arm-arm-none-eabi
    CFLAGS_CLANG += --target=arm-arm-none-eabi

	ifeq ($(BS_FIRMWARE_CPU), cortex-m4)
	    BS_ARCH_ARCH := armv7e-m
	    CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16  # hardware floating point support
	    LDFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16  #hardware floating point support
	else
	    BS_ARCH_ARCH := armv7-m
	    CFLAGS += -mfloat-abi=soft # No hardware floating point support
	endif

	CFLAGS += -mno-unaligned-access # Disable unaligned access code generation
else ifeq ($(BS_FIRMWARE_CPU),host)
    BS_ARCH_ARCH := host

else
    $(erro "$(BS_FIRMWARE_CPU) is not a supported CPU. Aborting...")
endif

endif
