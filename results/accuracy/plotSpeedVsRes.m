function plotAccVsRes()

res = [32 48 64 80 96 128];
acc = zeros(numel(res),2);

for i=1:numel(res)
    resolution = res(i);
    [b1,c1] = analyze_data(resolution);
    acc(i,1) = b1;
    acc(i,2) = c1;
end

%close all;
%h = figure(7);
%plot( res, acc(:,2) * 100, 'kx-', res, acc(:,1) * 100 , 'ko-');
%legend('GPU', 'CPU', 'Location', 'SouthEast');
%xlabel('Window width (pixels)');
%ylabel('Recognition Rate (%)');
%ylim([0 100]);

%set (h,'windowstyle','normal');               %   Window must be undocked for the following
%set (h,'Units','Inches');                     %   Using units of inches
%windowSize = [0 0 3.75 2];
%set(h,'position', windowSize);
%set(h, 'PaperPosition', windowSize);

%print(h, '../../figures/accuracyVsResolution.eps', '-depsc2');

%end
