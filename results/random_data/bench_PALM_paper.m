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

for i=2:3
    name = [type '_' num2str(n) '_' num2str(i) '_'];
    
    gpuName = [name 'GPU.mat'];
    
    gpuData = load(gpuName);
    
    blasName = [name 'BLAS.mat'];
    
    blasData = load(blasName);
    
    gpuDimsPowers  = gpuData.dimsPowers;
    gpuDimLen      = numel(gpuData.dimsPowers <= 6000);
    blasDimsPowers = blasData.dimsPowers;
    blasDimLen     = numel(blasData.dimsPowers <= 6000);
    
    subplot(1, 2, i-1);
    plotA = squeeze(gpuData.averageRunTime(2,1,:,2,2))';
    plotC = squeeze(blasData.averageRunTime(2,1,:,3,2))';
    plot(gpuDimsPowers(1:gpuDimLen), plotA(1:gpuDimLen), 'bx-');
    hold on
    plot(blasDimsPowers(1:blasDimLen), plotC(1:blasDimLen), 'g+-');
    title(['Tolerance 1e-3, Inner Tolerance 1e-2']);
    ylabel('Elapsed time (s)');
    xlabel(['A matrix dimension (m x 0.' num2str(i) 'm)']);
    hold off
    legend('gpu', 'cpu');
    
    
end
set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
set (gcf,'Units','Inches');                     %   Using units of inches
pos=get(gcf,'position');                        %   Save position values
set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings

plot2svg(['time_vs_matrix_size.svg'], h, 'png');
%saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');


end