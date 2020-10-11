# Paths
SRCDIR := src
OBJDIR := dist
SRC := $(SRCDIR)/master-editor.s
BIN := $(OBJDIR)/a.out
PRG := $(OBJDIR)/master-editor.prg
D64 := $(OBJDIR)/master-editor.d64

# Commands
MKBIN = dasm $(SRC) -o$(BIN)
MKPRG = exomizer sfx 0x8000 -o $(PRG) $(BIN)
MKD64 = mkd64 -o $(D64) -m cbmdos -d 'MASTER EDITOR' -m separators \
-f $(PRG) -n 'MASTER EDITOR' -w
RM := rm -rf
MKDIR := mkdir -p
X64 := x64sc

# Targets
.PHONY: all clean run

all: $(D64)

$(BIN): | $(OBJDIR)

$(OBJDIR):
	$(MKDIR) $(OBJDIR)

clean:
	$(RM) $(OBJDIR)

run: $(PRG)
	$(X64) $(PRG)

# Rules
$(BIN): $(SRC)
	$(MKBIN)
	
$(PRG): $(BIN)
	$(MKPRG)

$(D64): $(PRG) 
	$(MKD64)
