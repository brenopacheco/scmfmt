CC   := $(shell which chicken-csc)
BIN  := scmfmt
SRC  := scmfmt.scm

scmfmt: scmfmt.scm
	$(CC) scmfmt.scm -o scmfmt

clean:
	@echo "Cleaning up"
	rm -f scmfmt

.PHONY: clean scmfmt
