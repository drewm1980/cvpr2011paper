set terminal epslatex 
set output 'alignment_runtime_graph.tex'
set xlabel "Number of users in training set"
set ylabel "Alignment Stage Runtime (seconds)"
set yrange [0:]
set style data linespoints 
set pointsize 0.5
plot "alignment_runtime_graph_reference_cpu.dat" using 1:2 title '2 x Intel E5530 @ 2.4 GHz', \
"alignment_runtime_graph_reference_gpu.dat" using 1:2 title 'NVIDIA GTX480 @ 1.4GHz'



