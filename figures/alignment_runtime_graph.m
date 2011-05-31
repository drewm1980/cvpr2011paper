
% For MATLAB, you might need to manually remove the first row if there is a header.
cpu1=load('alignment_runtime_graph_reference_cpu.dat');
cpu2=load('alignment_runtime_graph_reference_cpu_percore.dat');
gtx480=load('alignment_runtime_graph_reference_gtx480.dat');
gtx580=load('alignment_runtime_graph_reference_gtx580.dat');

userCount = cpu1(:,1);

cpu1 = cpu1(:,2);
cpu2 = cpu2(:,2);
gtx480 = gtx480(:,2);
gtx580 = gtx580(:,2);

close all;
h = figure(7);
plot( userCount, gtx480, 'kx-' , userCount, gtx580, 'ko-' , userCount, cpu1, 'ks-' , userCount, cpu2, 'kd-');
legend('gtx480', 'gtx580', '2 x E5530, single instance', '2 x E5530, 1 instance per core');
xlabel('Number of training users');
ylabel('Elapsed time (s)');

set (h,'windowstyle','normal');               
set (h,'Units','Inches');                    
%windowSize = [0 0 3.75 2];
windowSize = [0 0 20 15];
set(h,'position', windowSize);
set(h, 'PaperPosition', windowSize);
print(h, 'alignment_runtime_graph.eps', '-deps2');

