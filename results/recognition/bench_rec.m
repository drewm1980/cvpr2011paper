function rtn = bench_rec()

type = 'PALM';
tols = [1e-3 1e-4 1e-5];

h = figure;

name = [type '_rec_'];

gpuName = [name 'GPU.mat'];

gpuData = load(gpuName);

cpuName = [name 'CPU.mat'];

cpuData = load(cpuName);

gpuNumUsers = gpuData.numUsers(gpuData.numUsers < 50);
gpuNUlen    = numel(gpuNumUsers);
cpuNumUsers = cpuData.numUsers(cpuData.numUsers < 50);
cpuNUlen    = numel(cpuNumUsers);

for j=1:numel(tols)
    
    subplot(numel(tols), 2, (j-1)*2+1);
    plotA = gpuData.averageRunTime(j,:,2,2);
    plotB = cpuData.averageRunTime(j,:,1,2);
    plot(gpuNumUsers, squeeze(plotA(1:gpuNUlen)), 'bx-');
    hold on
    plot(cpuNumUsers, squeeze(plotB(1:cpuNUlen)), 'r+-');
    title(['Average runtime - tolerance ' num2str(tols(j))]);
    xlabel('Number of Users');
    hold off
    
    subplot(numel(tols), 2, (j-1)*2+2);
    plotA = gpuData.averageIteration(j,:,2);
    plotB = cpuData.averageIteration(j,:,1);
    plot(gpuNumUsers, squeeze(plotA(1:gpuNUlen)), 'bx-');
    hold on
    plot(cpuNumUsers, squeeze(plotB(1:cpuNUlen)), 'r+-');
    title(['Average iterations - tolerance ' num2str(tols(j))]);
    xlabel('Number of Users');
    hold off
end

set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
set (gcf,'Units','Inches');                     %   Using units of inches
pos=get(gcf,'position');                        %   Save position values
set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings

plot2svg([type '_benchmark.svg'], h, 'png');
%saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');

end