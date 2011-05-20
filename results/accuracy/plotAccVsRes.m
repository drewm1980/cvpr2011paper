function plotAccVsRes()
%%
res = [32 48 64 80 96 128];
acc = zeros(numel(res),2);

for i=1:numel(res)
    resolution = res(i);
    [b1,c1] = analyze_data(resolution);
    acc(i,1) = b1;
    acc(i,2) = c1;
end
%%
close all;
h = figure;
plot(res, acc(:,1) * 100 , '--o', res, acc(:,2) * 100, 'x-');
legend('CPU', 'GPU', 'Location', 'best');
xlabel('Resolution');
ylabel('Accuracy %');
ylim([0 100]);

set (h,'windowstyle','normal');               %   Window must be undocked for the following
set (h,'Units','Inches');                     %   Using units of inches
pos=get(h,'position');                        %   Save position values
set (h,'position',[pos(1),pos(2),pos(1)+3.75,pos(2)]);       %   and set plot area to 5 by 3.75
set(h, 'PaperPosition', [0 0 3.75 3]);
print(h, '../../figures/accuracyVsResolution.eps', '-depsc2');
print(h, 'accuracyVsResolution.eps', '-depsc2');

end