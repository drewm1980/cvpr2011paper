load('sorted_user_ranks.dat');

h = figure;
[a, x] = hist(sorted_user_ranks, 100);
a = a / sum(a);
bar(x,a);

b = [a(1)];
for i=2:numel(a)
    b(i) = a(i) + b(i-1);
end
plot(x,b);

xlabel('Number of users with lower residual that test user');
ylabel('Percentage that user lies in training set');
title('Percentage that usre lies in training set based on alignment residuals')

set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
set (gcf,'Units','Inches');                     %   Using units of inches
pos=get(gcf,'position');                        %   Save position values
set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings

plot2svg(['user_alignment_rank_plot.svg'], h, 'png');
