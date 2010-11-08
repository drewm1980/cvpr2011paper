function rtn = bench_rec()

type = 'PALM';
tols = [1e-3 1e-4 1e-5];
tol_ints = [1e-3 1e-4 1e-5 1e-6];

h = figure;

sizes = {'small', 'big'};

for size=sizes
    
    size = size{1};
    
    name = [type '_rec_'];
    
    gpuName = [name 'GPU_' size '.mat'];
    
    gpuData = load(gpuName);
    
    cpuName = [name 'CPU_' size '.mat'];
    
    cpuData = load(cpuName);
    
    blasName = [name 'BLAS_' size '.mat'];
    
    blasData = load(blasName);
    
    gpuNumUsers = gpuData.numUsers(gpuData.numUsers < 50);
    gpuNUlen    = numel(gpuNumUsers);
    cpuNumUsers = cpuData.numUsers(cpuData.numUsers < 50);
    cpuNUlen    = numel(cpuNumUsers);
    blasNumUsers = blasData.numUsers(blasData.numUsers < 50);
    blasNUlen    = numel(blasNumUsers);
    
    for j=1:numel(tols)
        
        plotNum = 1;
        
        for k = 1:numel(tol_ints);
            
            subplot(numel(tol_ints), 2, plotNum);
            plotA = gpuData.averageRunTime(j,k,:,2,2);
            plotB = cpuData.averageRunTime(j,k,:,1,2);
            plotC = blasData.averageRunTime(j,k,:,3,2);
            plot(gpuNumUsers, squeeze(plotA(1:gpuNUlen)), 'bx-');
            hold on
            plot(cpuNumUsers, squeeze(plotB(1:cpuNUlen)), 'r+-');
            plot(blasNumUsers, squeeze(plotC(1:blasNUlen)), 'g+-');
            title(['Outer tolerance: ' num2str(tols(j)) '   inner tolerance: ' num2str(tol_ints(k))]);
            ylabel('Average runtime (s)');
            xlabel('Number of Users');
            hold off
            
            subplot(numel(tol_ints), 2, plotNum+1);
            plotA = gpuData.averageIteration(j,k,:,2);
            plotB = cpuData.averageIteration(j,k,:,1);
            plotC = blasData.averageIteration(j,k,:,3);
            plot(gpuNumUsers, squeeze(plotA(1:gpuNUlen)), 'bx-');
            hold on
            plot(cpuNumUsers, squeeze(plotB(1:cpuNUlen)), 'r+-');
            plot(blasNumUsers, squeeze(plotC(1:blasNUlen)), 'g+-');
            title(['Outer tolerance: ' num2str(tols(j)) '   inner tolerance: ' num2str(tol_ints(k))]);
            ylabel('Average iterations');
            xlabel('Number of Users');
            hold off
            
            plotNum = plotNum + 2;
        end
        
        set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
        set (gcf,'Units','Inches');                     %   Using units of inches
        pos=get(gcf,'position');                        %   Save position values
        set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
        set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
        
        plot2svg([type '_benchmark' num2str(j) '_' size '.svg'], h, 'png');
        %saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');
        
    end
    
end

end