PREFIX ?= /usr/local
BINPATH := $(PREFIX)/bin
EXEC := pd.sh

install:
		cp $(EXEC) $(BINPATH)
		chmod 0755 $(BINPATH)/$(EXEC)
		@echo Done

.PHONY: install
