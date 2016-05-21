main: embersExp.pdf

embersExp.pdf:
	pdflatex embersExp_kdd16
	bibtex embersExp_kdd16
	pdflatex embersExp_kdd16
	pdflatex embersExp_kdd16

arxiv_embersExp.pdf: 
	#arxiv_embersExp.tex references.bib $(wildcard sections/*.tex) $(wildcard figures/*/*.pdf) references.bib
	pdflatex arxiv_embersExp
	bibtex arxiv_embersExp
	pdflatex arxiv_embersExp
	pdflatex arxiv_embersExp


clean:
	-rm -f *.aux *.blg *.bbl *.log *.synctex.gz *.dvi arxiv_embersExp.pdf
