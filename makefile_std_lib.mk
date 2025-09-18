
# STD Defines
DDEFS += -DGD32F30X_HD -DUSE_STDPERIPH_DRIVER

# define gd32f30x lib dir
GD32F30x_LIB_DIR  = $(ROOT_DIR)/Drivers
# source director
GD32F3_STD_LIB     = $(GD32F30x_LIB_DIR)/GD32F30x_standard_peripheral
GD32F3_SRC_DIR     = $(GD32F3_STD_LIB)/Source
GD32F3_INC_DIR     = $(GD32F3_STD_LIB)/Include
GD32F3_CORE_DIR    = $(GD32F30x_LIB_DIR)/Core/CMSIS
GD32F3_DEVICE_DIR  = $(GD32F30x_LIB_DIR)/Core/CMSIS/GD/GD32F30x/Source
GD32F3_INC_DEVICE_DIR  = $(GD32F30x_LIB_DIR)/Core/CMSIS/GD/GD32F30x/Include

# startup
ASM_SRC  += $(GD32F3_CORE_DIR)/startup_gd32f303x_hd.S

# CMSIS

#C_SOURCES  += $(GD32F3_CORE_DIR)/core_cm3.c
#C_SOURCES  += $(GD32F3_DEVICE_DIR)/syscalls.c
C_SOURCES  += $(GD32F3_DEVICE_DIR)/system_gd32f30x.c

# use libraries, please add or remove when you use or remove it.
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_adc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_bkp.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_can.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_crc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_ctc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_dac.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_dbg.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_dma.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_enet.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_exmc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_exti.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_fmc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_fwdgt.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_gpio.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_i2c.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_misc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_pmu.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_rcu.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_rtc.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_sdio.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_spi.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_timer.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_usart.c
C_SOURCES  += $(GD32F3_SRC_DIR)/gd32f30x_wwdgt.c

# include directories
C_INCLUDES += $(GD32F3_CORE_DIR)
C_INCLUDES += $(GD32F3_INC_DEVICE_DIR)
C_INCLUDES += $(GD32F3_INC_DIR )

