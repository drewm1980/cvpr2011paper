recognition_times % Run extract_times.sh to generate this file.

close all;
h = figure(7);
plot( res, cudatimes, 'kx-', res, blastimes, 'ko-');
legend('GPU', 'CPU', 'Location', 'SouthEast');
xlabel('Window width (pixels)');
ylabel('Elapsed time (s)');

set (h,'windowstyle','normal');               
set (h,'Units','Inches');                    
windowSize = [0 0 3.75 2];
set(h,'position', windowSize);
set(h, 'PaperPosition', windowSize);
print(h, '../../figures/speedVsResolution.eps', '-deps2');

