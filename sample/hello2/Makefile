CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
CFLAGS = -march=rv32im
LDFLAGS = -L/opt/riscv32im/riscv32-unknown-elf/lib -Tlink.ld -nostartfiles -static 
LIBS = -lc
OBJS = hello2.o start.o
PROGRAM = hello2
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

$(PROGRAM): $(OBJS)
	$(LD) $(OBJS) $(LIBS) $(LDFLAGS) -o $(PROGRAM)
	$(OBJCOPY) -O binary $(PROGRAM) $(PROGRAM).bin
	$(OBJDUMP) -s -S $(PROGRAM) > $(PROGRAM).dump
	hexdump -v -e '1/4 "%08x" "\n"' $(PROGRAM).bin > $(PROGRAM).hex
	../bin2mif -4 hello2
	cp $(PROGRAM).hex ~/CloudStation/FPGAMAG18/FPGA/src/imem.hex 
	cp $(PROGRAM).mif ~/CloudStation/FPGAMAG18/FPGA/src/imem.mif 

start.o: start.S
	$(CC) $(CFLAGS) -c -o start.o start.S

hello2.o: hello2.c
	$(CC) $(CFLAGS) -c -o hello2.o hello2.c

all: $(PROGRAM)

clean:
	rm hello2 *.o hello2.dump hello2.hex hello2.bin hello2.mif
