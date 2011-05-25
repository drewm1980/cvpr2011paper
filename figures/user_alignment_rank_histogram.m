load('sorted_user_ranks.dat');

h = figure(6);
[a, x] = hist(sorted_user_ranks, 100);
a = a / sum(a)*100;
bar(x,a);

b = [a(1)];
for i=2:numel(a)
    b(i) = a(i) + b(i-1);
end
b = b;
plot(x+1,b,'k.-');

xlabel('Number of users in reduced training set');
%ylabel('Probability that user lies in reduced training set');
ylabel('Probability');

set (h,'windowstyle','normal');               %   Window must be undocked for the following
set (h,'Units','Inches');                     %   Using units of inches
windowSize = [0 0 3.75 2];
set(h,'position', windowSize);
set(h, 'PaperPosition', windowSize);

print(h, 'user_alignment_rank_plot.eps', '-deps2');
%plot2svg(['user_alignment_rank_plot.svg'], h, 'png');
