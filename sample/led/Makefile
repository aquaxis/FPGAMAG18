CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
CFLAGS = -march=rv32im
LDFLAGS = -L/opt/riscv32im/riscv32-unknown-elf/lib -Tlink.ld -nostartfiles -static 
LIBS = -lc
OBJS = led.o start.o
PROGRAM = led
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

$(PROGRAM): $(OBJS)
	$(LD) $(OBJS) $(LIBS) $(LDFLAGS) -o $(PROGRAM)
	$(OBJCOPY) -O binary $(PROGRAM) $(PROGRAM).bin
	$(OBJDUMP) -s -S $(PROGRAM) > $(PROGRAM).dump
	hexdump -v -e '1/4 "%08x" "\n"' $(PROGRAM).bin > $(PROGRAM).hex
	../bin2mif -4 led
	cp $(PROGRAM).hex ../../romdata/artya7.hex 
	cp $(PROGRAM).mif ../../romdata/max10.mif 

start.o: start.S
	$(CC) $(CFLAGS) -c -o start.o start.S

led.o: led.c
	$(CC) $(CFLAGS) -c -o led.o led.c

all: $(PROGRAM)

clean:
	rm led *.o led.dump led.hex led.bin
