# Use 'make DOC' for appropriate values of DOC to build the corresponding document
#
# DOC defines the version of the document being generated.
# Set DOC to one of draft, markup, local, submission, final, finaldraft, web, tr, trdraft, blindtr
# See paperversions.tex for the explanation of how the versions differ.
DOC = draft

# Name of the top-level TeX file sans .tex extension. Often the name of a conference, e.g. pldi18.
CONF = paper

TARGETS = $(DOC).pdf

# TeX source files
TEXS = $(DOC).tex abstract.tex header.tex body.tex

# Included figures (usually .pdf files)
FIGS =

# Change PAPERSROOT to wherever the papers/ directory is located
PAPERSROOT = .
MAKEDIR = $(PAPERSROOT)/make

include $(MAKEDIR)/commondefs

# Change to wherever you put paperversions.tex and the .sty files.
TEXDIR = $(PAPERSROOT)/tex-macros

default: $(TARGETS)

BIBFILE = dummy.bib

$(DOC).pdf: $(TEXS) $(FIGS) $(DOC).stamp $(DOC).bbl $(BIBFILE)
$(DOC).bbl: $(BIBFILE) $(DOC).stamp

$(DOC).tex: $(CONF).tex
	sed s/DOC/$(DOC)/ < $(CONF).tex > $(DOC).tex
   
LDIRT = local.tex markup.tex draft.tex submission.tex final.tex finaldraft.tex tr.tex trdraft.tex blindtr.tex web.tex
GENERATED += local.* markup.* draft.* submission.* final.* finaldraft.* tr.* trdraft.* blindtr.* web.*

include $(COMMONRULES)
