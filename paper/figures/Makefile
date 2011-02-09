TARGETS=pipeline.pdf alignment_l1.pdf
all: ${TARGETS} 

%.pdf:%.dia
	dia $< -e $@ 
	pdfcrop --margins "0" $@ $@

clean:
	rm -f ${TARGETS} 

