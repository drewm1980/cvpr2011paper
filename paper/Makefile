TARGETS=main.pdf 
all: ${TARGETS} 

main.pdf:main.tex figures/pipeline.tex

%.tex:%.dia
	dia $< -e $@ -t tex

%.pdf:%.tex
	latexmk -pdfdvi $<

#latexmk -pdf main.tex
#latexmk -pdfdvi main.tex
#latexmk -pdfps main.tex
