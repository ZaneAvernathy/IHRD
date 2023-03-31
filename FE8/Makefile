
.PHONY: fe8_all $(FE8_YEARS)

export EADIR   = $(TOOLSDIR)/EventAssembler
export CLIBDIR = $(TOOLSDIR)/CLib

export PF = $(TOOLSDIR)/ParseFile

export EA    = $(EADIR)/ColorzCore
export EADEP = $(EADIR)/Tools/ea-dep
export LYN   = $(EADIR)/Tools/lyn

FE8_EVENT_MAIN = $(FE8DIR)/Buildfile.event
EAFLAGS := -input:"$(FE8_EVENT_MAIN)" --nocash-sym

FE8DEPS := $(shell "$(EADEP)" "$(FE8_EVENT_MAIN)" -I "$(EADIR)" --add-missings)

# Ensure that dkA is installed.
ifeq ($(strip $(DEVKITARM)),)
  $(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_tools

.SUFFIXES:

include $(FE8DIR)/Code.mak

fe8_all: $(FE8DEPS) $(FE8_YEARS) | $(DESTDIR)
	@cp -f "$(FE8_BASEROM)" "$(DESTDIR)/IHRD_FE8_all.gba"
	@cd "$(EADIR)" && "$(EA)" A FE8 $(EAFLAGS) \
	-D:USE_ALL=True \
	-output:"$(DESTDIR)/IHRD_FE8_all.gba" \
	|| ($(RM) "$(DESTDIR)/IHRD_FE8_all.gba" "$(DESTDIR)/IHRD_FE8_all.sym" && false)

$(FE8_YEARS): $(FE8DEPS) | $(DESTDIR)
	@cp -f "$(FE8_BASEROM)" "$(DESTDIR)/IHRD_$@.gba"
	@cd "$(EADIR)" && "$(EA)" A FE8 $(EAFLAGS) \
	-D:USE_$@=True \
	-output:"$(DESTDIR)/IHRD_$@.gba" \
	|| ($(RM) "$(DESTDIR)/IHRD_$@.gba" "$(patsubst %.gba,%.sym,$(DESTDIR)/IHRD$@.gba)" && false)

%.txt.bin: %.txt
	@$(NOTIFY_PROCESS)
	@"$(PF)" "$<" --q -o "$@" -defs "$(dir $<)ParseDefinitions.txt"

# Clean generated files

ifneq (, $(findstring clean,$(MAKECMDGOALS)))

  FE8_TEXT_GENERATED := $(wildcard $(FE8DIR)/2023/TEXT/*.txt.bin)

endif

clean::
	@$(RM) $(FE8_TEXT_GENERATED)
