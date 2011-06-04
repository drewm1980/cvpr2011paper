
% For MATLAB, you might need to manually remove the first row if there is a header.
cpu1=load('alignment_runtime_graph_reference_cpu.dat');
cpu2=load('alignment_runtime_graph_reference_cpu_percore.dat');
gtx480=load('alignment_runtime_graph_reference_gtx480.dat');
gtx580=load('alignment_runtime_graph_reference_gtx580.dat');

%userCount = cpu1(:,1);
%cpu1 = cpu1(:,2);
%cpu2 = cpu2(:,2);
%gtx480 = gtx480(:,2);
%gtx580 = gtx580(:,2);

userCount = cpu1(1:2:end,1);
cpu1 = cpu1(1:2:end,2);
cpu2 = cpu2(1:2:end,2);
gtx480 = gtx480(1:2:end,2);
gtx580 = gtx580(1:2:end,2);
close all;
h = figure(7);

%plot( userCount, gtx480, 'k-.', userCount, gtx580, 'k-' , userCount, cpu1, 'k:' , userCount, cpu2, 'k--');
%legend('gtx480 GPU', 'gtx580 GPU', '2 x E5530 CPU, single instance', '2 x E5530 CPU, 1 instance per core', 'Location','NorthWest');

%plot( userCount, gtx580, 'k-' , userCount, cpu1, 'k:' , userCount, cpu2, 'k--');
plot( userCount, gtx580, 'kx-' , userCount, cpu1, 'k*-' , userCount, cpu2, 'ko-');
legend('gtx580 GPU', '2 x E5530 CPU, single instance', '2 x E5530 CPU, 1 instance per core','Location', 'NorthWest');

xlabel('Number of training users');
ylabel('Elapsed time (s)');

set (h,'windowstyle','normal');               
%set (h,'Units','Inches'); % matlab
set (h,'Units','inches'); % octave
windowSize = [0 0 3.75 2];
windowSize = windowSize*0.8;
%windowSize = windowSize*1.5;
%windowSize = windowSize*4;
%windowSize = [0 0 20 15];
set(h,'position', windowSize);
set(h, 'PaperPosition', windowSize);
print(h, 'alignment_runtime_graph.eps', '-deps2');
print(h, 'alignment_runtime_graph.png', '-dpng');

