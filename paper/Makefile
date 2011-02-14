TARGETS=main.pdf 
all: ${TARGETS} 

%.tex:%.dia
	dia $< -e $@ -t tex

%.pdf:%.tex
	latexmk -pdfdvi $<

#latexmk -pdf main.tex
#latexmk -pdfdvi main.tex
#latexmk -pdfps main.tex
