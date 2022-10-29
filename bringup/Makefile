all:	loop.hex nop.hex scroll.hex

clean:
	$(RM) *.hex *.s19 *.s37 *.lst *.bin

.SUFFIXES:	.hex .asm .s19 .s37 .bin

.asm.bin:
	pasm-68k -d1000 -F bin -o $@ $< > $@.lst

.asm.hex:
	pasm-68k -d1000 -F hex -o $@ $< > $@.lst

.asm.s19:
	pasm-68k -d1000 -F srec2 -o $@ $< > $@.lst

.asm.s37:
	pasm-68k -d1000 -F srec4 -o $@ $< > $@.lst
