DOC ?= draft

PAPERSROOT = .
MAKEDIR = $(PAPERSROOT)/make
BIBFILE = bibliography.bib
TARGETS = make $(DOC).pdf

sinclude $(MAKEDIR)/commondefs

export TEXINPUTS = acmart:syntax:sty:tex-macros:sections:

# Included figures (usually .pdf files)
FIGS = $(wildcard figures/*)
CODEFIGS = $(wildcard figures/*.code)
ACMART = acmart/acmart.cls acmart/ACM-Reference-Format.bst

TEXDIRS = $(subst :, ,$(TEXINPUTS))
SUBDIRTEXS = $(foreach DIR,$(TEXDIRS),$(wildcard $(DIR)/*.sty $(DIR)/*.tex))
TEXS = $(DOC).tex paper.tex header.tex body.tex $(wildcard *.sty) $(SUBDIRTEXS) \
	$(CODEFIGS:.code=.code.tex) \
	$(ACMART)

default: $(TARGETS)
.PHONY: default

SUBMODULES = make acmart
# add more submodules here, e.g., tex-macros, bibtex

$(DOC).pdf: $(TEXS) $(FIGS) $(DOC).stamp $(SUBMODULES) $(DOC).bbl $(BIBFILE)
$(DOC).bbl: $(BIBFILE) $(DOC).stamp

$(DOC).tex:
	printf '\\newcommand{\\paperversion}{${DOC}}\n\\input{paper}' > $@

$(DOC)-archive.tex: $(DOC).pdf
	latexpand $(DOC).tex > $@

$(DOC)-archive.zip: $(ACMART) $(DOC)-archive.tex
	zip $@ $^ $(DOC).bbl

$(SUBMODULES):
	$(MAKE) submodules
	@echo "Run make again!"

submodules:
	git submodule update --init --recursive
.PHONY: submodules

$(ACMART): acmart
	$(MAKE) -C acmart $(notdir $@)

debug:
	@echo "TARGETS = $(TARGETS)"
	@echo "TEXS = $(TEXS)"
	@echo "FIGS = $(FIGS)"
.PHONY: debug

figures/%.code.tex: figures/%.code texify-code.pl
	perl texify-code.pl $< > $@

LDIRT = local.* draft.* submission.* final.*                         \
	finaldraft.* tr.* trdraft.* blindtr.* web.*                  \
	*-archive.*                                                  \
	figures/*.code.tex *.fdb_latexmk *.fls *.cut *.up*

include $(COMMONRULES)

print-%  : ; @echo $* = $($*)
