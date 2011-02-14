TARGETS= pipeline.tex \
		 pipeline_simplified.tex \
		 alignment_l1.tex
all: ${TARGETS} 

%.pdf:%.dia
	dia $< -e $@ 
	pdfcrop --margins "0" $@ $@

%.tex:%.dia
	dia $< -e $@ -t tex

%.eps:%.png
	convert -compress zip $< eps2:$@

clean:
	rm -f ${TARGETS} 

