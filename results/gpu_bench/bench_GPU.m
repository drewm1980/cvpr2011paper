function rtn = bench_PALM()

type = 'benchGPU';
n  = 10; % denominator for ratio
ks = 0.1;
tols = [1e-4];
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
        
    gpuDimsPowers  = gpuData.dimsPowers;
    gpuDimLen      = numel(gpuData.dimsPowers <= 6000);

    gpuASize       = (gpuDimsPowers.^2 * i / 10 * 32) / (2^20);
        
    for j=1:numel(tols)
        
        subplot(numel(tols), 3, (j-1)*3+1);
        gpuOutIter  = squeeze(gpuData.averageIteration(j,j,:,2))'*5;
        
        % Calculations for totalSize (aka the number of times we use each
        % matrix * size of the matrix
        % A is mxn.  G is nxn.  (3*m*n) * totalOutIterations + (n^2)
        % * total Inner iterations.  Is that correct?
        gpuTotalSize    = gpuASize .* gpuOutIter / (2^10);

        plotA = squeeze(gpuData.averageRunTime(j,j,:,2,2))'; % multiply by 5 because I had A1 to A5 all run "maxIter" times
        plot(gpuASize(1:gpuDimLen), gpuTotalSize(1:gpuDimLen)./plotA(1:gpuDimLen), 'bx-');
        title(['ratio 10 to ' num2str(i)]);
        ylabel('Average speed (Gbits/s)');
        xlabel('A (in Mbits)');
        hold off
        
        if j == 1
            legend('GPU');
        end
%         
%         subplot(numel(tols), 3, (j-1)*3+2);
%         plotA = gpuData.averageL2error(j,j,:,2);
%         plotB = cpuData.averageL2error(j,j,:,1);
%         plotC = blasData.averageL2error(j,j,:,3);
%         plot(gpuDimsPowers, squeeze(plotA(1:gpuDimLen)), 'bx-');
%         hold on
%         plot(cpuDimsPowers, squeeze(plotB(1:cpuDimLen)), 'r+-');
%         plot(blasDimsPowers, squeeze(plotC(1:blasDimLen)), 'g+-');
%         title(['Tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
%         ylabel('Average L2 error');
%         xlabel('A & G Matrix (in Mb)');
%         hold off

%         subplot(numel(tols), 3, (j-1)*3+2);
%         plotA = gpuData.averageTotalInnerIteration(j,j,:,2);
%         plotB = cpuData.averageTotalInnerIteration(j,j,:,1);
%         plotC = blasData.averageTotalInnerIteration(j,j,:,3);
%         plot(gpuASize(1:gpuDimLen), squeeze(plotA(1:gpuDimLen)), 'bx-');
%         hold on
%         plot(cpuASize(1:cpuDimLen), squeeze(plotB(1:cpuDimLen)), 'r+-');
%         plot(blasASize(1:blasDimLen), squeeze(plotC(1:blasDimLen)), 'g+-');
%         title(['Tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
%         ylabel('Average total inner iterations');
%         xlabel('A & G Matrix (in Mb)');
%         hold off
% 
%         subplot(numel(tols), 3, (j-1)*3+3);
%         plotA = gpuData.averageIteration(j,j,:,2);
%         plotB = cpuData.averageIteration(j,j,:,1);
%         plotC = blasData.averageIteration(j,j,:,3);
%         plot(gpuASize(1:gpuDimLen), squeeze(plotA(1:gpuDimLen)), 'bx-');
%         hold on
%         plot(cpuASize(1:cpuDimLen), squeeze(plotB(1:cpuDimLen)), 'r+-');
%         plot(blasASize(1:blasDimLen), squeeze(plotC(1:blasDimLen)), 'g+-');
%         title(['Tolerance ' num2str(tols(j)) ' ratio ' num2str(i)]);
%         ylabel('Average iterations');
%         xlabel('A & G Matrix (in Mb)');
%         hold off
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