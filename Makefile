main: embersExp_kdd16.pdf


embersExp_kdd16.pdf: embersExp_kdd16.tex references.bib $(wildcard sections/*.tex) $(wildcard figures/*/*.pdf)
	pdflatex embersExp_kdd16
	bibtex embersExp_kdd16
	pdflatex embersExp_kdd16
	pdflatex embersExp_kdd16

clean:
	-rm -f *.aux *.blg *.bbl *.log *.synctex.gz *.dvi embersExp_kdd16.pdf
