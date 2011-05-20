load('sorted_user_ranks.dat');

h = figure;
[a, x] = hist(sorted_user_ranks, 100);
a = a / sum(a)*100;
bar(x,a);

b = [a(1)];
for i=2:numel(a)
    b(i) = a(i) + b(i-1);
end
b = b;
plot(x+1,b);

xlabel('Number of users in reduced training set');
%ylabel('Probability that user lies in reduced training set');
ylabel('Probability');

% set (gcf,'windowstyle','normal');               %   Window must be undocked for the following
% set (gcf,'Units','Inches');                     %   Using units of inches
% pos=get(gcf,'position');                        %   Save position values
% set (gcf,'position',[pos(1),pos(2),12,10]);       %   and set plot area to 5 by 3.75
% set(gcf,'paperpositionmode','auto');            %   Set output to WYSIWYG for current screen settings

set (h,'windowstyle','normal');               %   Window must be undocked for the following
set (h,'Units','Inches');                     %   Using units of inches
pos=get(h,'position');                        %   Save position values
set (h,'position',[pos(1),pos(2),pos(1)+3.75,pos(2)]);       %   and set plot area to 5 by 3.75
set(h, 'PaperPosition', [0 0 3.75 3]);


print(h, 'user_alignment_rank_plot.eps', '-depsc2');
%plot2svg(['user_alignment_rank_plot.svg'], h, 'png');
