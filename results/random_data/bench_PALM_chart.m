%function rtn = bench_PALM_paper()

type = 'PALM1';
n  = 10; % denominator for ratio
ks = 0.1;
maxIter = 5000;
iterations = 10;
dimsPowers = [500:100:900 1000:1000:10000];
lambda = 10;
%tols = gpuData.tols;
%tol_ints = gpuData.tol_ints;

% ratio, tol, tol_int, l2diff, blasl2err, gpul2err
data = [];

% xn1size, xn1time, xsize, xtime, x1size, x1time
level_sets = [];
level_times = [];
i = 0;

for ratio=2:4
    name = [type '_' num2str(ratio) '_' num2str(n) '_'];
    
    gpuName = [name 'GPU.mat'];
    gpuData = load(gpuName);
    
    blasName = [name 'BLAS.mat'];
    blasData = load(blasName);
    
    for j=1:numel(gpuData.tols)
        for k=1:numel(gpuData.tol_ints)
            i = i + 1;
            data(i,1)  = ratio;
            data(i,2)  = gpuData.tols(j);
            data(i,3)  = gpuData.tol_ints(k);
            data(i,6)  = mean(squeeze(gpuData.averageL2error(j,k,:,2)));
            data(i,5)  = mean(squeeze(blasData.averageL2error(j,k,:,3)));
            data(i,4)  = mean(squeeze(gpuData.averageL2error(j,k,:,2))-squeeze(blasData.averageL2error(j,k,:,3)));
            %             plot(squeeze(gpuData.averageRunTime(j,k,:,2,2)));
            %             hold on;
            %             plot(squeeze(blasData.averageRunTime(j,k,:,3,2)), 'r');
            %             hold off;
            
            count = 0;
            
            for m=-0.5:0.5:0.5
                count = count + 1;
                xpoint  = find(squeeze(gpuData.averageRunTime(j,k,:,2,2)) + m/2 > squeeze(blasData.averageRunTime(j,k,:,3,2))==0,1);
                if isempty(xpoint);
                    xpoint = inf;
                    xtime  = inf;
                else
                    xtime = squeeze(gpuData.averageRunTime(j,k,xpoint,2,2));
                    xpoint = gpuData.dimsPowers(xpoint);
                end
                level_sets(i,count) = xpoint;
                level_times(i,count) = xtime;
            end
        end
    end
end

save('speed_vs_matrix_size', 'data', 'level_sets', 'level_times');

%%

ratios = data(:,1);
tols   = data(:,2);
tol_ints = data(:,3);

clear('xpoint', 'xtime');

color = ['r', 'b', 'g', 'k', 'c'];
note  = ['o', 'x', '.', 's', '*'];

plotX = [];
plotY = [];

for ratio=unique(ratios)'
    h = figure;
    %hold on;
    unique_tols = unique(tols');
    plotX = [];
    plotY = [];
    for j = 1:numel(unique_tols)
        same = (ratios==ratio) & (tols == unique_tols(j));
        
        [xpoint, xin] = min(level_sets(same,:),[],1);
        xtimes = level_times(same,:); %,xin(2));
        for k=1:size(xtimes,2)
            xtime(k) = xtimes(xin(k), k);
        end
        
        plotX = [plotX; xpoint];
        plotY = [plotY; unique_tols(j) unique_tols(j) unique_tols(j)]; % unique_tols(j) unique_tols(j)];
    end
        
    semilogy(plotX, plotY, '-o');
    set(gca, 'ydir', 'reverse');
    ylabel(['Outer tolerance level']);
    xlabel('A matrix');
    xlabel(['A matrix (m x ' num2str(ratio/10) 'm)']);
    xlim([min(min(plotX))-500 max(max(plotX))+500]);
    %legend('GPU slower by 1 second','GPU slower by 1/2 second', 'GPU = CPU speed', 'GPU faster by 1/2 second', 'GPU faster by 1 second');
    legend('GPU slower by 1/2 second', 'GPU = CPU speed', 'GPU faster by 1/2 second');
    %axis([]);
    
    %hold off;
    set (h,'windowstyle','normal');               %   Window must be undocked for the following
    set (h,'Units','Inches');                     %   Using units of inches
    pos=get(h,'position');                        %   Save position values
    set (h,'position',[pos(1),pos(2),11,6]);       %   and set plot area to 5 by 3.75
    set(h,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
    
    plot2svg(['size_vs_speed_crossover_ratio_' num2str(ratio) '.svg'], h, 'png');
end

%saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');