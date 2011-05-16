imsize = 64;
dir  = ['size' num2str(imsize) 'x' num2str(imsize) '/no_perturb/'];
blas = importdata([dir 'blas_recognition_output_keepers_50.txt']);
cuda = importdata([dir 'cuda_recognition_output_keepers_50.txt']);


labels = {'upload time', 'solve time', 'user names', 'threshold', 'tol', ...
    'tol_int', 'maxIterInner', 'maxIterOuter', 'm', 'n', 'k', ...
    'solve_nIter', 'imagesPerUser', 'SCI', 'trueUserRank', ...
    'user_names (in order)', 'user residual values', ...
    'user names', 'x'};

rows = size(blas.textdata,1);
true_user   = zeros(rows, 1);
for i=1:rows
    true_user(i) = str2double(blas.textdata{i,3});
end

up_time     = [blas.data(:,1), cuda.data(:,1)];
solve_time  = [blas.data(:,2), cuda.data(:,2)];
threshold   = mean([blas.data(:,4), cuda.data(:,4)]);
tolerance   = mean([blas.data(:,5), cuda.data(:,5)]);
tol_int     = mean([blas.data(:,6), cuda.data(:,6)]);
maxIterInner = mean([blas.data(:,7), cuda.data(:,7)]);
maxIterOuter = mean([blas.data(:,8), cuda.data(:,8)]);
m           = mean([blas.data(:,9), cuda.data(:,9)]);
n           = mean([blas.data(:,10), cuda.data(:,10)]);
k           = mean([blas.data(:,11), cuda.data(:,11)]);
iter        = [blas.data(:,12), cuda.data(:,12)];
imagesPerUser = mean([blas.data(:,13), cuda.data(:,13)]);
SCI         = [blas.data(:,14), cuda.data(:,14)];
trueUserRank = [blas.data(:,15), cuda.data(:,15)];

start_row = 16;
end_row = start_row+k-1;
users_ordered = {blas.data(:,start_row:end_row),cuda.data(:,start_row:end_row)};

start_row = end_row+1;
end_row = start_row+k-1;
users_residuals = {blas.data(:,start_row:end_row),cuda.data(:,start_row:end_row)};

start_row = end_row+1;
end_row = start_row+k-1;
users_names = {blas.data(:,start_row:end_row),cuda.data(:,start_row:end_row)};

start_row = end_row+1;
end_row = start_row+n-1;
x = {blas.data(:,start_row:end_row),cuda.data(:,start_row:end_row)};

alignFail = zeros(3,1);
table = zeros(50,1);
for x=1:size(SCI,1)
    
    if true_user(x) > 250
        continue;
    end
    
    a2 = users_names{1}(x,:);
    b2 = users_names{2}(x,:);
    d1 = intersect(a2,b2);
    d2 = numel(d1);
    table(d2) = table(d2) + 1;
    
    if isempty(intersect(true_user(x), users_names{1}(x,:)))
        alignFail(1) = alignFail(1) + 1;
        %disp(['Index: ' num2str(x) ' True user was not outputted by BLAS alignment']);
    end
    if isempty(intersect(true_user(x), users_names{2}(x,:)))
        alignFail(2) = alignFail(2) + 1;
        %disp(['Index: ' num2str(x) ' True user was not outputted by CUDA alignment']);
    end
    
    if isempty(intersect(true_user(x), users_names{2}(x,:))) && isempty(intersect(true_user(x), users_names{1}(x,:)))
        alignFail(3) = alignFail(3) + 1;
    end
    
end

disp(['Number of times BLAS alignment fails: ' num2str(alignFail(1))]);
disp(['Number of times CUDA alignment fails: ' num2str(alignFail(2))]);
disp(['Number of times BOTH alignment fail : ' num2str(alignFail(3))]);

plot(table ./ size(SCI,1), '.-')
xlabel('Number of users');
ylabel('Percent occurence');
title('Number of users in common in CUDA and BLAS alignment');