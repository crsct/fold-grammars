PREFIX=/usr
TESTPREFIX=/home/sjanssen/Desktop/fold-grammars/Misc/Test-Suite/StefanStyle/

#programs
GAPC=gapc
MAKE=make
PERL=perl
PYTHON=python
INSTALL=install
SED=sed
CC=gcc
RSYNC=rsync
BASH=bash

#system dependend tools
TMPDIR := $(shell mktemp -d)
PWD := $(shell pwd)
ARCHTRIPLE := $(shell $(CC) -dumpmachine)

#fold-grammars specific variables
grammars=nodangle overdangle microstate macrostate
levels=5 4 3 2 1
isEval=0
RNAOPTIONSPERLSCRIPT=/Misc/Applications/addRNAoptions.pl

#compile options
CXXFLAGS_EXTRA=-O3 -DNDEBUG
FASTLIBRNA=
WINDOWSUFFIX=_window
window=
EXTRARUNTIMEPATHS=
ifdef window
	windowmodeflag=--window-mode
	current_windowmodesuffix=$(WINDOWSUFFIX)
else
	windowmodeflag=
	current_windowmodesuffix=
endif

dummy:
	@if [ "$(BASEDIR)" = "" ]; then \
		echo "To build all programs of the fold-grammars suite, type 'make build-suite' and 'make install-suite'!"; \
	else \
		echo "If you wan't to compile just one program from the fold-grammars suite, type 'make all' instead of 'make'!"; \
	fi;


# Build

build-suite: build-pkiss build-knotin build-palikiss build-rapidshapes build-shapes build-rapidshapes build-cofold build-hybrid build-acms

build-pkiss: 
	$(MAKE) -C Misc/Applications/pKiss all

build-palikiss:
	$(MAKE) -C Misc/Applications/pAliKiss all

build-shapes:
	$(MAKE) -C Misc/Applications/RNAshapes all

build-alishapes:
	$(MAKE) -C Misc/Applications/RNAalishapes all

build-knotin:
	$(MAKE) -C Misc/Applications/Knotinframe all

build-rapidshapes:
	$(MAKE) -C Misc/Applications/RapidShapes all

build-acms:
	$(MAKE) -C Misc/Applications/aCMs all

build-cofold:
	$(MAKE) -C Misc/Applications/RNAcofold all
	
build-hybrid:
	$(MAKE) -C Misc/Applications/RNAhybrid all

# Install 

install-knotin: install-lib
	$(MAKE) -C Misc/Applications/Knotinframe install-program

install-pkiss: install-lib
	$(MAKE) -C Misc/Applications/pKiss install-program

install-palikiss: install-lib
	$(MAKE) -C Misc/Applications/pAliKiss install-program

install-rapidshapes: install-lib
	$(MAKE) -C Misc/Applications/RapidShapes install-program

install-alishapes: install-lib
	$(MAKE) -C Misc/Applications/RNAalishapes install-program

install-shapes: install-lib
	$(MAKE) -C Misc/Applications/RNAshapes install-program

install-locomotif: install-lib
	$(MAKE) -C Misc/Applications/Locomotif_wrapper install-program

install-acms: install-lib
	$(MAKE) -C Misc/Applications/aCMs install-program

install-cofold: install-lib
	$(MAKE) -C Misc/Applications/RNAcofold install-program

install-hybrid: install-lib
	$(MAKE) -C Misc/Applications/RNAhybrid install-program



install-suite: install-knotin install-pkiss install-palikiss install-rapidshapes install-alishapes install-shapes install-locomotif install-acms install-cofold install-hybrid

distclean-suite:
	$(MAKE) -C Misc/Applications/Knotinframe distclean
	$(MAKE) -C Misc/Applications/pKiss distclean
	$(MAKE) -C Misc/Applications/pAliKiss distclean
	$(MAKE) -C Misc/Applications/RapidShapes distclean
	$(MAKE) -C Misc/Applications/RNAalishapes distclean
	$(MAKE) -C Misc/Applications/RNAshapes distclean
	$(MAKE) -C Misc/Applications/aCMs distclean
	$(MAKE) -C Misc/Applications/RNAcofold distclean
	$(MAKE) -C Misc/Applications/RNAhybrid distclean

install-lib:
	$(MAKE) -C Misc/Applications/lib/ install

test-suite:
	if [ ! -d "$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)/bin" ]; then $(INSTALL) -d $(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)/bin; fi;
	$(MAKE) -C Misc/Applications/Knotinframe install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	$(MAKE) -C Misc/Applications/pKiss install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	$(MAKE) -C Misc/Applications/pAliKiss install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	$(MAKE) -C Misc/Applications/RapidShapes install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	$(MAKE) -C Misc/Applications/RNAalishapes install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	$(MAKE) -C Misc/Applications/RNAshapes install-program PREFIX=$(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)
	mv $(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)/bin/* $(TESTPREFIX)/$(ARCHTRIPLE)/$(ARCHTRIPLE)

compile:
	if [ ! -f "$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname)" ]; then \
		cd $(TMPDIR) && $(GAPC) -I $(PWD)/$(BASEDIR) -p "$(gapc_product)" $(gapc_options) $(PWD)/$(BASEDIR)/$(gapc_file); \
		$(PERL) $(PWD)/$(BASEDIR)/$(RNAOPTIONSPERLSCRIPT) $(TMPDIR)/out.mf $(isEval) '$(gapc_binaryname)' '$(gapc_product)'; \
		cd $(TMPDIR) && $(MAKE) -f out.mf CPPFLAGS_EXTRA="-I $(PWD)/$(BASEDIR) -I ./" CXXFLAGS_EXTRA="$(CXXFLAGS_EXTRA)" $(FASTLIBRNA) LDFLAGS_EXTRA="$(EXTRARUNTIMEPATHS)"; \
		$(INSTALL) -d $(PWD)/$(ARCHTRIPLE); \
		$(INSTALL) $(TMPDIR)/out $(PWD)/$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname); \
	fi;
	cd $(PWD) && rm -rf $(TMPDIR);

compile_instance:
	if [ ! -f "$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname)" ]; then \
		cd $(TMPDIR) && $(GAPC) -I $(PWD)/$(BASEDIR) -i "$(gapc_instance)" $(gapc_options) $(PWD)/$(BASEDIR)/$(gapc_file); \
		$(PERL) $(PWD)/$(BASEDIR)/$(RNAOPTIONSPERLSCRIPT) $(TMPDIR)/out.mf $(isEval) '$(gapc_binaryname)' '$(gapc_product)'; \
		cd $(TMPDIR) && $(MAKE) -f out.mf CPPFLAGS_EXTRA="-I $(PWD)/$(BASEDIR) -I ./" CXXFLAGS_EXTRA="$(CXXFLAGS_EXTRA)" $(FASTLIBRNA) LDFLAGS_EXTRA="$(EXTRARUNTIMEPATHS)"; \
		$(INSTALL) -d $(PWD)/$(ARCHTRIPLE); \
		$(INSTALL) $(TMPDIR)/out $(PWD)/$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname); \
	fi;
	cd $(PWD) && rm -rf $(TMPDIR);

compile_mea:
	if [ ! -f "$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname)" ]; then \
		cd $(TMPDIR) && $(GAPC) -I $(PWD)/$(BASEDIR) -p "$(gapc_product1)" $(gapc_options1) $(PWD)/$(BASEDIR)/$(gapc_file1) -o bppm.cc; \
		cd $(TMPDIR) && $(SED) -i "s/namespace gapc {/namespace outside_gapc {/" bppm.hh; \
		cd $(TMPDIR) && $(SED) -i 's|#include .rtlib/generic_opts.hh.|#include "Extensions/rnaoptions.hh"|' bppm.hh; \
		cd $(TMPDIR) && $(SED) -i 's|#include .rtlib/generic_opts.hh.|#include "Extensions/rnaoptions.hh"|' bppm.cc; \
		cd $(TMPDIR) && $(GAPC) -I $(PWD)/$(BASEDIR) -p "$(gapc_product2)" $(gapc_options2) $(PWD)/$(BASEDIR)/$(gapc_file2); \
		$(PERL) $(PWD)/$(BASEDIR)/$(RNAOPTIONSPERLSCRIPT) $(TMPDIR)/out.mf 2 '$(gapc_binaryname)' '$(gapc_product)'; \
		cd $(TMPDIR) && $(MAKE) -f out.mf bppm.o CPPFLAGS_EXTRA="-I $(PWD)/$(BASEDIR) -I ./" CXXFLAGS_EXTRA="$(CXXFLAGS_EXTRA)" $(FASTLIBRNA) LDFLAGS_EXTRA="$(EXTRARUNTIMEPATHS)"; \
		cd $(TMPDIR) && $(MAKE) -f out.mf CPPFLAGS_EXTRA="-I $(PWD)/$(BASEDIR) -I ./" CXXFLAGS_EXTRA="$(CXXFLAGS_EXTRA)" $(FASTLIBRNA) LDFLAGS_EXTRA="bppm.o $(EXTRARUNTIMEPATHS)"; \
		$(INSTALL) -d $(PWD)/$(ARCHTRIPLE); \
		$(INSTALL) $(TMPDIR)/out $(PWD)/$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname); \
	fi;
	cd $(PWD) && rm -rf $(TMPDIR);

compile_local:
	if [ ! -f "$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname)" ]; then \
		cd $(TMPDIR) && ln -s $(PWD)/$(BASEDIR)/$(gapc_file) .; \
		mkdir -p $(TMPDIR)/Grammars; \
		cat $(PWD)/$(BASEDIR)/Grammars/$(GRAMMARFILE) | sed "s|axiom = struct|axiom = local|" > $(TMPDIR)/Grammars/gra_pknot_microstate.gap; \
		cd $(TMPDIR) && $(GAPC) -I $(PWD)/$(BASEDIR) -p "$(gapc_product)" $(gapc_options) $(PWD)/$(BASEDIR)/$(gapc_file); \
		$(PERL) $(PWD)/$(BASEDIR)/$(RNAOPTIONSPERLSCRIPT) $(TMPDIR)/out.mf $(isEval) '$(gapc_binaryname)' '$(gapc_product)'; \
		cd $(TMPDIR) && $(MAKE) -f out.mf CPPFLAGS_EXTRA="-I $(PWD)/$(BASEDIR) -I ./" CXXFLAGS_EXTRA="$(CXXFLAGS_EXTRA)" $(FASTLIBRNA) LDFLAGS_EXTRA="$(EXTRARUNTIMEPATHS)"; \
		$(INSTALL) -d $(PWD)/$(ARCHTRIPLE); \
		$(INSTALL) $(TMPDIR)/out $(PWD)/$(ARCHTRIPLE)/$(PROGRAMPREFIX)$(gapc_binaryname); \
	fi;
	cd $(PWD) && rm -rf $(TMPDIR);

test: build-suite
	cd Misc/Test-Suite/GeorgStyle/ && $(BASH) run.sh ../Truth
	cd Misc/Test-Suite/StefanStyle/ && $(PERL) runTests.pl
	cd Misc/Test-Suite/StefanStyle/ && $(PYTHON) test_cofold.py
