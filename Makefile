NAME=embersExp_kdd16
RUBBER=
# $(shell which rubber)
PDFLATEXARGS=-shell-escape
#$(PWD))

all: $(NAME).pdf

DEPENDENCIES=$(wildcard sections/*.tex)
BIBTEXS=references.bib

ifneq "$(RUBBER)" ""

$(NAME).pdf: $(NAME).tex $(DEPENDENCIES) $(BIBTEXS)
	$(RUBBER) --pdf $<
	$(RUBBER)-info $<
clean: 
	$(RUBBER) --pdf --clean $(NAME).tex

else

$(NAME).pdf: $(NAME).tex $(DEPENDENCIES) $(BIBTEXS)
	pdflatex $(PDFLATEXARGS) $<
	bibtex  $(basename $<)
	pdflatex $(PDFLATEXARGS) $< 
	pdflatex $(PDFLATEXARGS) $<
	grep --color=auto  "LaTeX Warning" $(basename $<).log || true

$(NAME)_final.pdf: $(NAME).tex $(DEPENDENCIES) $(BIBTEXS)
	latex $(PDFLATEXARGS) $<
	bibtex  $(basename $<)
	latex $(PDFLATEXARGS) $< 
	latex $(PDFLATEXARGS) $<
	dvips -P pdf -t letter -o $(NAME)_final.ps $(NAME).dvi
	ps2pdf $(NAME)_final.ps

spellcheck: $(NAME).tex $(DEPENDENCIES)
	@TERM=xterm-color 
	@for file in $^; do \
		echo Spellchecking $$file ; \
		aspell --local-data-dir=./ --home-dir=./ -t check $$file ; \
	done


clean:
	rm -rf ${NAME}.aux ${NAME}.bbl ${NAME}.blg ${NAME}.log ${NAME}.pdf ${NAME}.toc ${NAME}.snm ${NAME}.out ${NAME}.nav tags

endif
.PHONY: all clean
