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

h = figure(4);

for i=5
    name = [type '_' num2str(i) '_' num2str(n) '_'];
    
    gpuName = [name 'GPU.mat'];
    
    gpuData = load(gpuName);
    
    blasName = [name 'BLAS.mat'];
    
    blasData = load(blasName);
    
    gpuDimsPowers  = gpuData.dimsPowers;
    gpuDimLen      = sum(gpuData.dimsPowers <= 8000);
    blasDimsPowers = blasData.dimsPowers;
    blasDimLen     = sum(blasData.dimsPowers <= 8000);
    
    gpuASize       = (gpuDimsPowers.^2 * i / 10 ) * 4 / (2^20);
    blasASize      = (blasDimsPowers.^2 * i / 10 ) * 4 / (2^20);
    
    %subplot(1, 3, i-1);
    % index 1 is outer tolerance
    % index 2 is inner tolerance
    % index 3 is different resolutions
    % index 4 is (2) GPU (3) BLAS
    % index 5 is (1) time to upload (2) time to solve (3) time to free memory

    plotA = squeeze(gpuData.averageRunTime(3,3,:,2,2))';
    plotC = squeeze(blasData.averageRunTime(3,3,:,3,2))';
    %plot(gpuASize(1:gpuDimLen), plotA(1:gpuDimLen), 'bx-');
    plot(gpuDimsPowers(1:gpuDimLen), plotA(1:gpuDimLen), 'kx-');
    hold on
    plot(blasDimsPowers(1:blasDimLen), plotC(1:blasDimLen), 'ko-');
    %title(['Tolerance ' num2str(tols(1)) ', Inner Tolerance ' num2str(tol_ints(5))]);
    ylabel('Elapsed time (s)');
    %axis([0 100 0 30])
    xlabel(['m (A is size ' num2str(i/10) 'm x m)']);
    %xlabel(['A matrix dimension (m x 0.' num2str(i) 'm)']);
    hold off
    legend('GPU', 'CPU', 'Location', 'NorthWest');
    
end

i = 1;


set (h,'windowstyle','normal');               %   Window must be undocked for the following
set (h,'Units','Inches');                     %   Using units of inches
pos=get(h,'position');                        %   Save position values
windowSize = [0 0 3.75 2];
%set(h,'position', [pos(1),pos(2),pos(1),pos(2)]+windowSize);
set(h,'position', windowSize);
%set (h,'position',[pos(1),pos(2),pos(1)+3.75,pos(2)]);       %   and set plot area to 5 by 3.75
set(h, 'PaperPosition', windowSize);

%print(h, '../../figures/time_vs_matrix_size_constant_tol.eps', '-depsc2');
print(h, '../../figures/time_vs_matrix_size_constant_tol.eps', '-deps2');
%print(h, 'time_vs_matrix_size_constant_tol.eps', '-depsc2');

% set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
% set (gcf,'Units','Inches');                     %   Using units of inches
% pos=get(gcf,'position');                        %   Save position values
% set (gcf,'position',[pos(1),pos(2),12,6]);       %   and set plot area to 5 by 3.75
% set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings

%plot2svg(['time_vs_matrix_size_constant_tol.svg'], h, 'png');
%saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');
