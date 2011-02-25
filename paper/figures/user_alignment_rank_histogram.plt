set terminal pdf enhanced
set output 'user_alignment_rank_histogram.pdf'
set title "Rank of the test user in the training set based on alignment residuals"
set xlabel "Number of users with lower residual that test user"
set ylabel "Frequency"

binwidth=5
bin(x,width)=floor(x/width)
plot 'sorted_user_ranks.dat' using (bin($1,binwidth)):(1.0) smooth freq with boxes

