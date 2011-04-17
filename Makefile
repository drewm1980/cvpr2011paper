TARGETS=main.pdf main_allen.pdf

all: ${TARGETS} 

main.pdf:main.tex figures/alignment_runtime_graph.eps
main_allen.pdf:main_allen.tex figures/alignment_runtime_graph.eps

# Always build main.pdf target, letting latexmk figure out all of the deps of main.pdf automatically

%.tex:%.dia
	dia $< -e $@ -t tex

%.pdf:%.tex
	latexmk -pdfdvi $<

clean:
	rm -f ${TARGETS} *.brf *.dvi *.log *.fdb_latexmk *.bbl *.aux

#latexmk -pdf main.tex
#latexmk -pdfdvi main.tex
#latexmk -pdfps main.tex
