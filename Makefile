TEXFILE	= overview.tex syllabus.tex

.PHONY: pdf clean 

.PRECIOUS: %.bbl

pdf:	$(TEXFILE:.tex=.pdf)

define run-latex
	( \
	latex $(<:.aux=.tex); \
	while grep -Eq "(undefined references|get cross-references right)" $(<:.aux=.log); \
	do \
		latex $(<:.aux=.tex); \
	done \
	)
endef

%.dvi: %.tex

%.aux: %.tex
	latex $<
	rm -f $(<:.tex=.dvi)

%.bbl: %.aux %.bib
	bibtex $<

%.dvi: %.aux %.bbl
	@$(run-latex)

%.dvi: %.aux
	@$(run-latex)

%.ps: %.dvi
	dvips -q $< -o $(<:.dvi=.ps)

%.pdf: %.ps
	ps2pdf $<

clean:
	@rm -f *.aux *.log *.out *.dvi *.pdf *.toc *.bbl *.blg *.ps
