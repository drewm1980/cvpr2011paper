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

ratios = [];
tols   = [];
tol_ints = [];

xsizes = [];
x1sizes = [];
xn1sizes = [];

xtimes = [];
x1sizes = [];
xn1sizes = [];

l2diff = [];
blasl2err = [];
gpul2err = [];

for i=2:4
    name = [type '_' num2str(n) '_' num2str(i) '_'];
    
    gpuName = [name 'GPU.mat'];
    gpuData = load(gpuName);
    
    blasName = [name 'BLAS.mat'];
    blasData = load(blasName);
    
    ratio = i;
    for j=1:numel(gpuData.tols)
        for k=1:numel(gpuData.tol_ints)
            ratios  = [ratios i];
            tols    = [tols gpuData.tols(j)];
            tol_ints  = [tol_ints gpuData.tol_ints(k)];
            gpul2err  = [ gpul2err gpuData.averageL2error(j,k,:,2)];
            blasl2err = [ blasl2err blasData.averageL2error(j,k,:,3)];
            l2diff    = [l2diff norm(squeeze(gpuData.averageL2error(j,k,:,2))-squeeze(blasData.averageL2error(j,k,:,3)))];
            %             plot(squeeze(gpuData.averageRunTime(j,k,:,2,2)));
            %             hold on;
            %             plot(squeeze(blasData.averageRunTime(j,k,:,3,2)), 'r');
            %             hold off;
            xpoint  = find(squeeze(gpuData.averageRunTime(j,k,:,2,2)) > squeeze(blasData.averageRunTime(j,k,:,3,2))==0,1);
            if isempty(xpoint);
                xpoint = -1;
                xtime = -1;
            else
                xtime = squeeze(gpuData.averageRunTime(j,k,xpoint,2,2));
                xpoint = gpuData.dimsPowers(xpoint);
            end
            xsizes = [xsizes xpoint];
            xtimes = [xtimes xtime];
            
            xpoint  = find(squeeze(gpuData.averageRunTime(j,k,:,2,2)) > squeeze(blasData.averageRunTime(j,k,:,3,2))==0,1);
            if isempty(xpoint);
                xpoint = -1;
                xtime = -1;
            else
                xtime = squeeze(gpuData.averageRunTime(j,k,xpoint,2,2));
                xpoint = gpuData.dimsPowers(xpoint);
            end
            xsizes = [xsizes xpoint];
            xtimes = [xtimes xtime];
        end
    end
end

ratios = ratios';
tols = tols';
tol_ints = tol_ints';
gpul2err = gpul2err';
blasl2err = blasl2err';
xsizes = xsizes';
xtimes = xtimes';
l2diff = l2diff';

save('speed_vs_matrix_size', 'ratios', 'tols', 'tol_ints', 'xsizes', 'xtimes', 'l2diff');

color = ['r', 'b', 'g', 'k', 'c'];
note  = ['o', 'x', '.', 's', '*'];
for i=2:4
    h = figure;
    trials = (ratios == i) & (xtimes ~= -1);
    m_size = xsizes(trials);
    times  = xtimes(trials);
    tol    = tols(trials);
    tol_int = tol_ints(trials);
    leg = {};
    unique_tol = unique(tol);
    hold on;
    
    colori = 0;
    count = 0;
    
    for j=unique_tol
        count = count + 1;
        %         for k=unique(tol_int)
        %             plotX = m_size(tol == j & tol_int == k);
        %             plotY = times(tol == j & tol_int == k);
        %             plot(plotX, plotY, [color(colori) note(notei)]);
        %         end
        leg{count} = ['Tol:' num2str(j)];
        plotX = m_size(tol == j);
        plotY = times(tol == j);
        plot(plotX, plotY, ['-o' color(count)]);
        %plot(plotX, plotY, [color(count) note(1)]);
    end
    
    hold off;
    legend(leg, 'Location', 'NorthWest');
    title(['Ratio: ' num2str(i)]);
    xlabel(['A matrix (m x ' num2str(i/10) 'm)']);
    ylabel('time (s)');
    set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
    set (gcf,'Units','Inches');                     %   Using units of inches
    pos=get(gcf,'position');                        %   Save position values
    set (gcf,'position',[pos(1),pos(2),12,6]);       %   and set plot area to 5 by 3.75
    set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings
    
    plot2svg(['size_vs_speed_crossover_ratio_' num2str(i) '.svg'], h, 'png');
    
end


%saveas(h, [type '_benchmark_ratio_' num2str(i)], 'jpg');