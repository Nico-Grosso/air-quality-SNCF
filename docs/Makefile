# Build all project documents: run "make" in docs/.
# Sources: latex/0*/<name>.tex   Output: pdf/<name>.pdf   Aux files: build/<name>/
SRCDIRS := $(wildcard latex/0*)
DOCS    := $(notdir $(basename $(wildcard latex/0*/*.tex)))
PDFS    := $(addprefix pdf/,$(addsuffix .pdf,$(DOCS)))
DEPS    := $(wildcard latex/common/*.tex) $(wildcard registers/*.csv) latexmkrc

export TEXINPUTS := $(CURDIR)/latex/common//:

vpath %.tex $(SRCDIRS)

.PHONY: all clean list $(DOCS)

all: $(PDFS)

pdf/%.pdf: %.tex $(DEPS)
	@mkdir -p pdf build/$*
	latexmk -r latexmkrc -outdir=build/$* $<
	cp build/$*/$*.pdf $@

# "make product-charter" builds one document.
$(DOCS): %: pdf/%.pdf

list:
	@echo $(DOCS)

clean:
	rm -rf build
