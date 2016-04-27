
LATEX	= latex -shell-escape
BIBTEX	= bibtex
DVIPS	= dvips
DVIPDF  = dvipdft
XDVI	= xdvi -gamma 4
GH		= gv

EXAMPLES = $(wildcard assign1.c)
SRC	:= $(shell egrep -l '^[^%]*\\begin\{document\}' *.tex)
TRG	= $(SRC:%.tex=%.dvi)
PSF	= $(SRC:%.tex=%.ps)
PDF	= $(SRC:%.tex=%.pdf)

pdf: $(PDF)

ps: $(PSF)

$(TRG): %.dvi: %.tex *.bib $(EXAMPLES)
	#one way of including source code is to use pygments
	pygmentize -f latex -o __${EXAMPLES}.tex ${EXAMPLES}


	$(LATEX) $<
	$(LATEX) $<
	$(LATEX) $<

	gcc -pthread assign1.c -o assign1

$(PSF):%.ps: %.dvi
	$(DVIPS) -R -Poutline -t letter $< -o $@

$(PDF): %.pdf: %.ps

	ps2pdf $<

show: $(TRG)
	@for i in $(TRG) ; do $(XDVI) $$i & done

showps: $(PSF)
	@for i in $(PSF) ; do $(GH) $$i & done

all: pdf

clean:
	rm -f *.pdf *.ps *.dvi *.out *.log *.aux *.bbl *.blg *.pyg

concurrency:
	gcc -pthread assign1.c -o assign1

.PHONY: all show clean ps pdf showps
