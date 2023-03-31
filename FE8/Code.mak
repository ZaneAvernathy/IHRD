
# Code helpers

LYN_REFERENCES := $(CLIBDIR)/reference/FE8U-20190316.o $(FE8DIR)/CommonDefinitions.o

FE8_CODE_INCLUDE_DIRS := "$(CLIBDIR)/include"
FE8_INCFLAGS          := $(foreach dir,$(FE8_CODE_INCLUDE_DIRS), -I "$(dir)")

# Assembly/compilation flags
FE8_ARCH     := -mcpu=arm7tdmi -mthumb -mthumb-interwork
FE8_CFLAGS   := $(FE8_ARCH) $(FE8_INCFLAGS) -Wall -Os -mtune=arm7tdmi -ffreestanding -fomit-frame-pointer -mlong-calls
FE8_INCFLAGS := $(FE8_ARCH) $(FE8_INCFLAGS)

# Dependency flags
FE8_CDEPFLAGS := -MMD -MT "$*.o" -MT "$*.asm" -MF "$(CACHEDIR)/$(notdir $*).d" -MP
FE8_SDEPFLAGS := --MD "$(CACHEDIR)/$(notdir $*).d"

%.lyn.event: %.o | $(LYN_REFERENCES) $(CACHEDIR)
	@$(NOTIFY_PROCESS)
	@"$(LYN)" "$<" $(foreach file,$(LYN_REFERENCES), "$(file)") > "$@" || ($(RM) "$@" && false)

%.dmp: %.o | $(CACHEDIR)
	@$(NOTIFY_PROCESS)
	@$"(OBJCOPY)" -S "$<" -O binary "$@"

%.o: %.s | $(CACHEDIR)
	@$(NOTIFY_PROCESS)
	@"$(AS)" $(FE8_ASFLAGS) $(FE8_SDEPFLAGS) -I "$(dir $<)" "$<" -o "$@" $(ERROR_FILTER)

# Skipping intermediate .s files because Stan says they break things.
%.o: %.c | $(CACHEDIR)
	@$(NOTIFY_PROCESS)
	@"$(CC)" $(FE8_CFLAGS) $(FE8_CDEPFLAGS) -g -c "$<" -o "$@" $(ERROR_FILTER)

%.asm: %.c | $(CACHEDIR)
	@$(NOTIFY_PROCESS)
	@"$(CC)" $(FE8_CFLAGS) $(FE8_CDEPFLAGS) -S "$<" -o "$@" -fverbose-asm $(ERROR_FILTER)

# Stan says that we need to avoid deleting intermediate .o files
# or dependency stuff will break, so:
# Also, I just want to keep intermediate files between builds, anyway.
.PRECIOUS: %.o %.asm %.lyn.event %.dmp

ifneq (,$(findstring clean,$(MAKECMDGOALS)))

  CFILES := $(shell find -type f -name '*.c')
  SFILES := $(shell find -type f -name '*.s')

  ASM_C_GENERATED := $(CFILES:.c=.o) $(SFILES:.s=.o) $(CFILES:.c=.asm)
  ASM_C_GENERATED += $(ASM_C_GENERATED:.o=.dmp) $(ASM_C_GENERATED:.o=.lyn.event)

endif

clean::
	@$(RM) $(ASM_C_GENERATED)

