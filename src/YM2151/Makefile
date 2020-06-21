#
# Makefile
#

.SUFFIXES: .asm .p .hex .sr


all:	YM2151-PLAY.hex sample_m.hex

.p.hex:
	p2hex -F Intel $*.p $*.hex

.p.sr:
	p2hex -F Moto $*.p $*.sr

.asm.p:	
	asl -L $*.asm

clean:
	rm -f *.p *.hex *.sr *.lst
