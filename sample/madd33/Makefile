CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
CFLAGS = -march=rv32im
LDFLAGS = -L/opt/riscv32im/riscv32-unknown-elf/lib -Tlink.ld -nostartfiles -static 
LIBS = -lc
OBJS = madd33.o start.o madd33_asm.o
PROGRAM = madd33
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

$(PROGRAM): $(OBJS)
	$(LD) $(OBJS) $(LIBS) $(LDFLAGS) -o $(PROGRAM)
	$(OBJCOPY) -O binary $(PROGRAM) $(PROGRAM).bin
	$(OBJDUMP) -s -S $(PROGRAM) > $(PROGRAM).dump
	hexdump -v -e '1/4 "%08x" "\n"' $(PROGRAM).bin > $(PROGRAM).hex
	../bin2mif -4 madd33
	cp $(PROGRAM).hex ../../romdata/artya7.hex 
	cp $(PROGRAM).mif ../../romdata/max10.mif 

start.o: start.S
	$(CC) $(CFLAGS) -c -o start.o start.S

madd33.o: madd33.c
	$(CC) $(CFLAGS) -c -o madd33.o madd33.c

madd33_asm.o: madd33_asm.S
	$(CC) $(CFLAGS) -c -o madd33_asm.o madd33_asm.S

all: $(PROGRAM)

clean:
	rm madd33 *.o madd33.dump madd33.hex madd33.bin madd33.mif
