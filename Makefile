
.PHONY: all fe5_all fe8_all clean veryclean
.SUFFIXES:

all: fe5_all fe8_all | $(DESTDIR)

SHELL = /bin/sh

# Folders

export ROOT := $(realpath .)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
ifneq (,$(findstring $(SPACE),$(ROOT)))

  $(error "Please avoid spaces in file paths.")

endif

export DESTDIR  = $(ROOT)/BIN
export CACHEDIR = $(ROOT)/.CACHE
export TOOLSDIR = $(ROOT)/TOOLS

export FE5DIR = $(ROOT)/FE5
export FE8DIR = $(ROOT)/FE8

# These are clean ROMs used to build the outputs

export FE5_BASEROM = $(ROOT)/FE5.sfc
export FE8_BASEROM = $(ROOT)/FE8U.gba

# General dependencies

ifeq ($(shell python -c "import sys; print(int(sys.version_info[0] > 2))"),1)
  export PYTHON = python
else
  export PYTHON = python3
endif

# Game-specific dependencies are handled in their individual makefiles.

export FE5_YEARS = 2019 2022
export FE8_YEARS = 2023
.PHONY: $(FE5_YEARS) $(FE8_YEARS)

export NOTIFY_PROCESS = @echo "$(notdir $<) => $(notdir $@)"

include $(FE5DIR)/Makefile
include $(FE8DIR)/Makefile

$(DESTDIR):
	@mkdir -p "$(DESTDIR)"

$(CACHEDIR):
	@mkdir -p "$(CACHEDIR)"

clean::
	@$(RM) "$(DESTDIR)"/*.*

veryclean:: clean
	@$(RM) -rf "$(DESTDIR)"
	@$(RM) -rf "$(CACHEDIR)"
