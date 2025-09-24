######################################
# target
######################################
TARGET = GD32_RTOS


######################################
# building variables
######################################
# debug build?
DEBUG = 1
# optimization
OPT = -Og


#######################################
# paths
#######################################
# Build path
BUILD_DIR = build
# define root dir
ROOT_DIR     = .

APP_PATH = $(ROOT_DIR)/App
APP_PATH_SRC = $(APP_PATH)/Source
APP_PATH_INC = $(APP_PATH)/Include
LEDDriver_PATH = $(ROOT_DIR)/Drivers/display

######################################
# source
######################################
# C sources
C_SOURCES =  \
$(APP_PATH_SRC)/encoder.c \
$(APP_PATH_SRC)/gd32f30x_it.c \
$(APP_PATH_SRC)/gpio.c \
$(APP_PATH_SRC)/i2c.c \
$(APP_PATH_SRC)/main.c \
$(APP_PATH_SRC)/spi.c \
$(APP_PATH_SRC)/systick.c \
$(APP_PATH_SRC)/tim.c \
$(APP_PATH_SRC)/usart.c \
$(LEDDriver_PATH)/OLED.c \
$(LEDDriver_PATH)/OLED_Fonts.c \
$(LEDDriver_PATH)/OLED_Icons.c \

C_INCLUDES =  	$(ROOT_DIR)
C_INCLUDES += 	$(APP_PATH_INC)
C_INCLUDES +=	$(LEDDriver_PATH)

# ASM sources
ASM_SOURCES = 

# include sub makefiles
include makefile_std_lib.mk   # GD32 Standard Peripheral Library
include makefile_freertos.mk  # freertos source

INC_DIR  = $(patsubst %, -I%, $(C_INCLUDES))

#######################################
# binaries
#######################################
PREFIX = arm-none-eabi-
# The gcc compiler bin path can be either defined in make command via GCC_PATH variable (> make GCC_PATH=xxx)
# either it can be added to the PATH environment variable.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S
 
#######################################
# CFLAGS
#######################################
# cpu
CPU = -mcpu=cortex-m4

# fpu
FPU = -mfpu=fpv4-sp-d16

# float-abi
FLOAT-ABI = -mfloat-abi=hard

# mcu
MCU = $(CPU) -mthumb $(FLOAT-ABI)  $(FPU)
#MCU = $(CPU) -mthumb 

# macros for gcc
# AS defines
AS_DEFS = 

# C defines
# Uncomment -DHID_IAP if you want a HID IAP application
C_DEFS =  \
-DGD32F30X_HD \
-DUSE_STDPERIPH_DRIVER \
#-DHID_IAP \

# AS includes
AS_INCLUDES = 

# include directories
#C_INCLUDES =  \
-I $(APP_PATH_INC) \
-I $(LEDDriver_PATH) \
-I $(GD32F3_INC_DEVICE_DIR) \
-I $(GD32F3_CORE_INC_DIR) \
-I $(GD32F3_INC_STDLIB) \
-I $(FREERTOS_INC_DIR) \
-I $(FREERTOS_ARM_CM4_DIR)

# compile gcc flags
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

#CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = $(MCU) $(C_DEFS) $(OPT) -Wall -fdata-sections -ffunction-sections

ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2 -std=gnu99
endif


# Generate dependency information
CFLAGS += -MMD -MP -MF"$(@:%.o=%.d)"


#######################################
# LDFLAGS
#######################################
# link script
LDSCRIPT = $(ROOT_DIR)/GD32F303CCTx.ld
# Uncomment this if you want a HID IAP application 
#LDSCRIPT = $(ROOT_DIR)/GD32F303CCTx_HID.ld

# libraries
LIBS = -lc -lm -lnosys 
LIBDIR = 
LDFLAGS = $(MCU) -u _printf_float -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# default action: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin


#######################################
# build the application
#######################################
# list of objects
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# list of ASM program objects
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR) 
#	$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@
	$(CC) -c $(CFLAGS) -I . $(INC_DIR) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/%.o: %.S Makefile | $(BUILD_DIR)
	$(AS) -c $(CFLAGS) $< -o $@

$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	@echo "\r\n---------------------   SIZE   ----------------------"
	$(CC) $(OBJECTS) $(LDFLAGS) -o $@ -Wl,--print-memory-usage
	@echo ""
	$(SZ) $@
	@echo "-----------------------------------------------------"

$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@
	
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@	
	
$(BUILD_DIR):
	mkdir $@		

#######################################
# clean up
#######################################
clean:
	-rm -Rf $(BUILD_DIR)
  
#######################################
# dependencies
#######################################
-include $(wildcard $(BUILD_DIR)/*.d)

#######################################
# prog
#######################################
GD32 = 1
ifeq ($(GD32), 1)
	MK = gd32f30x
else
	MK = stm32f4x
endif

CMSIS_DAP = 0
ifeq ($(CMSIS_DAP), 1)
	OCD_INTER = cmsis-dap
else
	OCD_INTER = stlink
endif

prog: $(BUILD_DIR)/$(TARGET).elf
	openocd -f  interface/$(OCD_INTER).cfg -f target/$(MK).cfg -c "program build/$(TARGET).elf verify exit reset"

# *** EOF ***