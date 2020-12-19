TARGET	:= cx16
SRCNAME := loadstore
PRGNAME	:= $(shell echo $(SRCNAME) | tr '[:lower:]' '[:upper:]').PRG

all: $(PRGNAME)

$(PRGNAME): $(SRCNAME).asm
	cl65 -t $(TARGET) -o $(PRGNAME) -l $(SRCNAME).list $<

run: $(PRGNAME)
	x16emu -debug -prg $(PRGNAME)

clean:
	@rm -f *.list *.PRG
