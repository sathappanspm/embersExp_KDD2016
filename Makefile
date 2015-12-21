main: Makefile
	pdflatex embersExp_kdd16
	pdflatex embersExp_kdd16
	bibtex embersExp_kdd16
	pdflatex embersExp_kdd16
	pdflatex embersExp_kdd16

clean:
	-rm -f *.aux *.blg *.bbl *.log *.synctex.gz *.dvi
