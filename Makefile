MCU = atmega328p
F_CPU = 8000000UL

TARGET = clock

PROGRAMMER_TYPE = buspirate
PROGRAMMER_ARGS = -P /dev/ttyUSB0

CC = avr-gcc
OBJCOPY = avr-objcopy
AVRDUDE = avrdude

# Files
SOURCES=$(wildcard src/*.c)
OBJECTS=$(SOURCES:.c=.o)
HEADERS=$(SOURCES:.c=.h)
ELF_FILE = $(TARGET).elf
HEX_FILE = $(TARGET).hex

CFLAGS += -Os -g -std=gnu99 -Wall
CFLAGS += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums
CFLAGS += -ffunction-sections -fdata-sections
CFLAGS += -DF_CPU=$(F_CPU)

LDFLAGS += -Wl,--gc-sections

TARGET_ARCH = -mmcu=$(MCU)

.PHONY: install clean all

all: $(HEX_FILE)

%.o: %.c $(HEADERS)
	-@echo "compiling $<" 
	@$(CC) $(CFLAGS) $(TARGET_ARCH) -c -o $@ $<

$(ELF_FILE): $(OBJECTS)
	-@echo "generating $@"
	@$(CC) $(LDFLAGS) $(TARGET_ARCH) $^ $(LDLIBS) -o $@

$(HEX_FILE): $(ELF_FILE)
	-@echo "generating $@"
	@$(OBJCOPY) -j .text -j .data -O ihex $< $@

install: $(HEX_FILE)
	-@echo "flashing $@"
	@$(AVRDUDE) -c $(PROGRAMMER_TYPE) -p $(MCU) $(PROGRAMMER_ARGS) -U flash:w:$<

clean:
	-@echo "cleaning *.o $(TARGET).elf and $(TARGET).hex"
	-@rm -f $(OBJECTS)
	-@rm -f $(TARGET).elf
	-@rm -f $(TARGET).hex

