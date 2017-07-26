CC = riscv32-unknown-elf-gcc
LD = riscv32-unknown-elf-ld
CFLAGS = -march=rv32im
LDFLAGS = -L/opt/riscv32im/riscv32-unknown-elf/lib -Tlink.ld -nostartfiles -static 
LIBS = -lc
OBJS = hello.o start.o
PROGRAM = hello
OBJCOPY = riscv32-unknown-elf-objcopy
OBJDUMP = riscv32-unknown-elf-objdump

$(PROGRAM): $(OBJS)
	$(LD) $(OBJS) $(LIBS) $(LDFLAGS) -o $(PROGRAM)
	$(OBJCOPY) -O binary $(PROGRAM) $(PROGRAM).bin
	$(OBJDUMP) -s -S $(PROGRAM) > $(PROGRAM).dump
	hexdump -v -e '1/4 "%08x" "\n"' $(PROGRAM).bin > $(PROGRAM).hex
	../bin2mif -4 hello
	cp $(PROGRAM).hex ../../romdata/artya7.hex 
	cp $(PROGRAM).mif ../../romdata/max10.mif 

start.o: start.S
	$(CC) $(CFLAGS) -c -o start.o start.S

hello.o: hello.c
	$(CC) $(CFLAGS) -c -o hello.o hello.c

all: $(PROGRAM)

clean:
	rm hello *.o hello.dump hello.hex hello.bin hello.mif
