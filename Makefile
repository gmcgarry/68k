all:

clean:
	$(RM) *.hex *.s19 *.lst *.bin

.SUFFIXES:	.hex .asm .s19 .bin

.asm.bin:
	pasm-68k -d1000 -F bin -o $@ $< > $@.lst

.asm.hex:
	pasm-68k -d1000 -F hex -o $@ $< > $@.lst

.asm.s19:
	pasm-68k -d1000 -F srec4 -o $@ $< > $@.lst
