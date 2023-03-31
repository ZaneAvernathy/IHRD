
.PHONY: fe5_all $(FE5_YEARS)

VOLTEDGEDIR = $(ROOT)/../VoltEdge
VOLTEDGE    = $(VOLTEDGEDIR)/VoltEdge.h

64TASS   = $(TOOLSDIR)/64tass
FE5DEP   = $(PYTHON) "$(TOOLSDIR)/scan_includes.py"

FE5_BUILD_MAIN = $(FE5DIR)/Build.asm

FE5_ASFLAGS := -a -x -f -C -Wall -Wno-portable -Wno-shadow -Wno-deprecated
FE5_ASFLAGS += -D BASEROM=\"$(FE5_BASEROM)\"
FE5_ASFLAGS += -i "$(VOLTEDGE)" -i "$(FE5_BUILD_MAIN)"

FE5DEPS := $(shell $(FE5DEP) "$(FE5_BUILD_MAIN)" "$(VOLTEDGE)")

fe5_all: $(FE5DEPS) $(FE5_YEARS) | $(DESTDIR)
	@"$(64TASS)" $(FE5_ASFLAGS) \
	-D USE_ALL:=true \
	-o "$(DESTDIR)/IHRD_FE5_all.sfc"

$(FE5_YEARS): $(FE5DEPS) | $(DESTDIR)
	@"$(64TASS)" $(FE5_ASFLAGS) \
	-D USE_$@:=true \
	-o "$(DESTDIR)/IHRD_$@.sfc"
