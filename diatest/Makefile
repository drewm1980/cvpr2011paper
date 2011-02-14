TARGETS=main.pdf 
all: ${TARGETS} 

main.pdf:diatest.tex
main.pdf:main.tex

%.tex:%.dia
	dia $< -e $@ -t tex

%.pdf:%.tex
	latexmk -pdfdvi $<

.PHONY:clean
clean:
	rm -f main.pdf diatest.tex *_latexmk *.dvi *.aux *.log *.dia~
