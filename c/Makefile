CC=m68k-linux-gnu-pcc
#CC=m68k-linux-gnu-gcc
OBJCOPY=m68k-linux-gnu-objcopy

#CFLAGS += -O -msoft-float
CFLAGS += -O -march=68000 -msoft-float

#LDFLAGS += -Wl,-T,ram.ld -Wl,--print-map
LDFLAGS += -Wl,-T,ram.ld

all:

clean:
	$(RM) test *.o *.s37 *.bin

test.s37: main.o
	$(CC) -v $(LDFLAGS) -o $@.s19 $^ -lio -lpccsoftfloat
	$(OBJCOPY) --srec-forceS3 $@.s19 $@
	$(RM) $@.s19

.SUFFIXES: .s37 .bin

.s37.bin:
	$(OBJCOPY) -I srec -O binary $^ $@

.o.s37:
	$(CC) -v $(LDFLAGS) -o $@.s19 $^ -lio -lpccsoftfloat
	$(OBJCOPY) --srec-forceS3 $@.s19 $@
	$(RM) $@.s19

.c.o:
	$(CC) $(CFLAGS) $(INC) -c -o $@ $<

.c.s:
	$(CC) $(CFLAGS) $(INC) -S -o $@ $<
