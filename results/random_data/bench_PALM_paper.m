function rtn = bench_PALM_paper()

type = 'PALM1';
n  = 10; % denominator for ratio
ks = 0.1;
maxIter = 5000;
iterations = 10;
dimsPowers = [500:100:900 1000:1000:10000];
lambda = 10;
ratio = 1:5;
%tols = gpuData.tols;
%tol_ints = gpuData.tol_ints;
tols = [1e-2 1e-3];
tol_ints = [1e-2 1e-3 1e-4];

h = figure;

for i=ratio
    name = [type '_' num2str(n) '_' num2str(i) '_'];
    
    gpuName = [name 'GPU.mat'];
    
    gpuData = load(gpuName);
    
    blasName = [name 'BLAS.mat'];
    
    blasData = load(blasName);

    gpuDimsPowers  = gpuData.dimsPowers;
    gpuDimLen      = numel(gpuData.dimsPowers <= 6000);
    blasDimsPowers = blasData.dimsPowers;
    blasDimLen     = numel(blasData.dimsPowers <= 6000);
    
    gpuASize       = (gpuDimsPowers.^2 * i / 10 * (1 + i / 10)) * 32 / (2^20);
    blasASize      = (blasDimsPowers.^2 * i / 10 * (1 + i / 10)) * 32 / (2^20);
    
    for j=1:numel(tols)
        for k=1:numel(tol_ints)
            
            subplot(numel(tol_ints), 3, (k-1)*3+1);
            gpuOutIter  = squeeze(gpuData.averageIteration(j,k,:,2))';
            gpuInIter   = squeeze(gpuData.averageTotalInnerIteration(j,k,:,2))';
            blasOutIter = squeeze(blasData.averageIteration(j,k,:,3))';
            blasInIter  = squeeze(blasData.averageTotalInnerIteration(j,k,:,3))';
            
            % Calculations for totalSize (aka the number of times we use each
            % matrix * size of the matrix
            % A is mxn.  G is nxn.  (3*m*n) * totalOutIterations + (n^2)
            % * total Inner iterations.  Is that correct?
            gpuTotalSize    = gpuDimsPowers.^2 .* ((3 * (i/10) .* gpuOutIter)  + (i/10)^2 .* gpuInIter) * 32 / (2^30);
            blasTotalSize   = blasDimsPowers.^2 .* ((3 * (i/10) .* blasOutIter)  + (i/10)^2 .* blasInIter) * 32 / (2^30);
            
            plotA = squeeze(gpuData.averageRunTime(j,k,:,2,2))';
            plotC = squeeze(blasData.averageRunTime(j,k,:,3,2))';
            plot(gpuASize(1:gpuDimLen), gpuTotalSize(1:gpuDimLen)./plotA(1:gpuDimLen), 'bx-');
            hold on
            plot(blasASize(1:blasDimLen), blasTotalSize(1:blasDimLen)./plotC(1:blasDimLen), 'g+-');
            title(['Tolerance ' num2str(tols(j)) ' Inner Tolerance ' num2str(tol_ints(k))]);
            ylabel('Average speed (Gbits/s)');
            xlabel('A & G Matrix (in Mbits)');
            hold off
            
            subplot(numel(tol_ints), 3, (k-1)*3+2);
            plotA = gpuData.averageL2error(j,k,:,2);
            plotC = blasData.averageL2error(j,k,:,3);
            plot(gpuDimsPowers, squeeze(plotA(1:gpuDimLen)), 'bx-');
            hold on
            plot(blasDimsPowers, squeeze(plotC(1:blasDimLen)), 'g+-');
            title(['Tolerance ' num2str(tols(j)) ' Inner Tolerance ' num2str(tol_ints(k))]);
            ylabel('Average L2 error');
            xlabel('A & G Matrix (in Mb)');
            hold off
            
%             subplot(numel(tol_ints), 3, (k-1)*3+3);
%             plotA = gpuData.averageTotalInnerIteration(j,k,:,2);
%             plotC = blasData.averageTotalInnerIteration(j,k,:,3);
%             plot(gpuASize(1:gpuDimLen), squeeze(plotA(1:gpuDimLen)), 'bx-');
%             hold on
%             plot(blasASize(1:blasDimLen), squeeze(plotC(1:blasDimLen)), 'g+-');
%             title(['Tolerance ' num2str(tols(j)) ' Inner Tolerance ' num2str(tol_ints(k))]);
%             ylabel('Average total inner iterations');
%             xlabel('A & G Matrix (in Mb)');
%             hold off
            
            subplot(numel(tol_ints), 3, (k-1)*3+3);
            plotA = gpuData.averageIteration(j,k,:,2);
            plotC = blasData.averageIteration(j,k,:,3);
            plot(gpuASize(1:gpuDimLen), squeeze(plotA(1:gpuDimLen)), 'bx-');
            hold on
            plot(blasASize(1:blasDimLen), squeeze(plotC(1:blasDimLen)), 'g+-');
            title(['Tolerance ' num2str(tols(j)) ' Inner Tolerance ' num2str(tol_ints(k))]);
            ylabel('Average iterations');
            xlabel('A & G Matrix (in Mb)');
            hold off
        end
        
        set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
        set (gcf,'Units','Inches');                     %   Using units of inches
        pos=get(gcf,'position');                        %   Save position values
        set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
        set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
        
        plot2svg([type '_benchmark_ratio_' num2str(i) '_tol_' num2str(tols(j)) '.svg'], h, 'png');
        %saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');
        
    end
end

end