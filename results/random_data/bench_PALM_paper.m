%function rtn = bench_PALM_paper()

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
tols = [1e-1 1e-2 1e-3 1e-4];
tol_ints = [1e-1 1e-2 1e-3 1e-4 1e-5];

h = figure;

for ratio_i=2:4
    
    
    for i=2:4
        name = [type '_' num2str(n) '_' num2str(ratio_i) '_'];
        
        gpuName = [name 'GPU.mat'];
        
        gpuData = load(gpuName);
        
        blasName = [name 'BLAS.mat'];
        
        blasData = load(blasName);
        
        gpuDimsPowers  = gpuData.dimsPowers;
        gpuDimLen      = sum(gpuData.dimsPowers <= 8000);
        blasDimsPowers = blasData.dimsPowers;
        blasDimLen     = sum(blasData.dimsPowers <= 8000);

        gpuASize       = (gpuDimsPowers.^2 * ratio_i / 10 ) * 4 / (2^20);
        blasASize      = (blasDimsPowers.^2 * ratio_i / 10 ) * 4 / (2^20);

        subplot(1, 3, i-1);
        plotA = squeeze(gpuData.averageRunTime(1,5,:,2,2))';
        plotC = squeeze(blasData.averageRunTime(1,5,:,3,2))';
        plot(gpuASize(1:gpuDimLen), plotA(1:gpuDimLen), 'bx-');
        hold on
        plot(blasASize(1:blasDimLen), plotC(1:blasDimLen), 'g+-');
        title(['Tolerance ' num2str(tols(1)) ', Inner Tolerance ' num2str(tol_ints(i))]);
        ylabel('Elapsed time (s)');
        %axis([0 100 0 30])
        xlabel(['Size of A matrix (KB)']);
        %xlabel(['A matrix dimension (m x 0.' num2str(i) 'm)']);
        hold off
        legend('gpu', 'cpu');
        
        
    end
    
    i = 1;
    
    set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
    set (gcf,'Units','Inches');                     %   Using units of inches
    pos=get(gcf,'position');                        %   Save position values
    set (gcf,'position',[pos(1),pos(2),12,6]);       %   and set plot area to 5 by 3.75
    set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
    
    plot2svg(['time_vs_matrix_size_ratio_' num2str(ratio(ratio_i)) '.svg'], h, 'png');
    %saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');
    
    
end