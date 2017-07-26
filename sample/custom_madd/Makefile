CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
CFLAGS = -march=rv32im
LDFLAGS = -L/opt/riscv32im/riscv32-unknown-elf/lib -Tlink.ld -nostartfiles -static
LIBS = -lc
OBJS = custom_madd.o start.o up_custom_madd.o
PROGRAM = custom_madd
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

$(PROGRAM): $(OBJS)
	$(LD) $(OBJS) $(LIBS) $(LDFLAGS) -o $(PROGRAM)
	$(OBJCOPY) -O binary $(PROGRAM) $(PROGRAM).bin
	$(OBJDUMP) -s -S $(PROGRAM) > $(PROGRAM).dump
	hexdump -v -e '1/4 "%08x" "\n"' $(PROGRAM).bin > $(PROGRAM).hex
	../bin2mif -4 custom_madd
	cp $(PROGRAM).hex ../../src/imem.hex
	cp $(PROGRAM).mif ../../src/imem.mif

start.o: start.S
	$(CC) $(CFLAGS) -c -o start.o start.S

up_custom_madd.o: up_custom_madd.S
	$(CC) $(CFLAGS) -c -o up_custom_madd.o up_custom_madd.S

custom_madd.o: custom_madd.c
	$(CC) $(CFLAGS) -c -o custom_madd.o custom_madd.c

all: $(PROGRAM)

clean:
	rm custom_madd *.o custom_madd.dump custom_madd.hex custom_madd.bin
