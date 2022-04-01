
.PHONY: all clean 2022
.SUFFIXES:

# Please edit these to match the locations
# of the required files.

BASEROM  := "../FE5.sfc"
VOLTEDGE := "../VoltEdge"
64tass   := "../Tools/64tass/64tass.exe"

ASFLAGS := -a -x -f -C -Wall -Wno-portable -Wno-shadow -Wno-deprecated
ASFLAGS += -D BASEROM=\"$(BASEROM)\"
ASFLAGS += -i "$(VOLTEDGE)/VoltEdge.h" -i "Build.asm"

DEPS := Build.asm BaseROM.asm

# This will build all IHRD projects individually as well
# as creating a file that implements all of them at once,
# for maximum fun.
all: $(DEPS) 2022
	@$(64tass) $(ASFLAGS) \
	-D USE_2022:=true \
	-o "IHRD_all.sfc"

2022: $(DEPS) 2022/2022.asm
	@$(64tass) $(ASFLAGS) -D USE_2022:=true -o "IHRD_2022.sfc"

clean:
	@$(RM) *.sfc *.srm *.bst *.sym *.sav *.ups
