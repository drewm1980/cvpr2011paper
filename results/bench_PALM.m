function rtn = bench_PALM()

type = 'PALM';
n  = 10; % denominator for ratio
ks = 0.1;
tols = [1e-4 1e-5 1e-6 1e-7];
maxIter = 5000;
iterations = 10;
dimsPowers = [500:100:900 1000:1000:10000];
lambda = 10;
ratio = 1:5;

h = figure;

for i=ratio
    name = [type '_' num2str(n) '_' num2str(i) '_'];
    
    gpuName = [name 'GPU.mat'];
    
    gpuData = load(gpuName);
    
    cpuName = [name 'CPU.mat'];
    
    cpuData = load(cpuName);
    
    gpuDimsPowers = gpuData.dimsPowers(gpuData.dimsPowers <= 2000);
    gpuDimLen     = numel(gpuDimsPowers);
    cpuDimsPowers = cpuData.dimsPowers(cpuData.dimsPowers <= 2000);
    cpuDimLen     = numel(cpuDimsPowers);
    
    for j=1:numel(tols)
        
        subplot(numel(tols), 3, (j-1)*3+1);
        plotA = gpuData.averageRunTime(j,j,:,2,2);
        plotB = cpuData.averageRunTime(j,j,:,1,2);
        plot(gpuDimsPowers, squeeze(plotA(1:gpuDimLen)), 'bx-');
        hold on
        plot(cpuDimsPowers, squeeze(plotB(1:cpuDimLen)), 'r+-');
        title(['Average runtime - tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
        hold off
        
        subplot(numel(tols), 3, (j-1)*3+2);
        plotA = gpuData.averageL2error(j,j,:,2);
        plotB = cpuData.averageL2error(j,j,:,1);
        plot(gpuDimsPowers, squeeze(plotA(1:gpuDimLen)), 'bx-');
        hold on
        plot(cpuDimsPowers, squeeze(plotB(1:cpuDimLen)), 'r+-');
        title(['Average L2 error - tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
        hold off
        
        subplot(numel(tols), 3, (j-1)*3+3);
        plotA = gpuData.averageIteration(j,j,:,2);
        plotB = cpuData.averageIteration(j,j,:,1);
        plot(gpuDimsPowers, squeeze(plotA(1:gpuDimLen)), 'bx-');
        hold on
        plot(cpuDimsPowers, squeeze(plotB(1:cpuDimLen)), 'r+-');
        title(['Average iterations - tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
        hold off
    end
    
    set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
    set (gcf,'Units','Inches');                     %   Using units of inches
    pos=get(gcf,'position');                        %   Save position values
    set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
    set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
    
    plot2svg([type '_benchmark_ratio_' num2str(i) '.svg'], h, 'png');
    %saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');
end

end