TARGETS = pipeline.tex \
		 pipeline_simplified.tex \
		 alignment_l1.tex \
		 alignment_runtime_graph.eps

all: ${TARGETS} EXTERNAL_DATA

.PHONY:EXTERNAL_DATA

EXTERNAL_DATA:
	copy_data_from_code_repo.sh


alignment_runtime_graph.eps:alignment_runtime_graph_reference_cpu.dat 
alignment_runtime_graph.eps:alignment_runtime_graph_reference_gpu.dat 
alignment_runtime_graph.eps:EXTERNAL_DATA

%.eps:%.plt 
	gnuplot $<

%.pdf:%.dia
	dia $< -e $@ 
	pdfcrop --margins "0" $@ $@

%.tex:%.dia
	dia $< -e $@ -t tex

%.eps:%.png
	convert -compress zip $< eps2:$@

clean:
	rm -f ${TARGETS} 

