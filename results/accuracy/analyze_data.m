function [blasAc, cudaAc] = analyze_data(imsize1)
imsize = 64;
saveQ = true;

if exist('imsize1', 'var')
    imsize = imsize1;
    saveQ = false;
end

dir  = ['size' num2str(imsize) 'x' num2str(imsize) '/no_perturb/'];
%dir  = ['size' num2str(imsize) 'x' num2str(imsize) '/1_1_3/'];
blas = importdata([dir 'blas_recognition_output_keepers_20.txt']);
cuda = importdata([dir 'cuda_recognition_output_keepers_20.txt']);
%save([dir 'blas_recognition_output_keepers_20.mat'],blas);
%save([dir 'cuda_recognition_output_keepers_20.mat'],cuda);
blas = load([dir 'blas_recognition_output_keepers_20.mat'],blas);
blas = load([dir 'cuda_recognition_output_keepers_20.mat'],cuda);

%%labels = {'upload time', 'solve time', 'user names', 'threshold', 'tol', ...
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
%threshold   = mean([blas.data(:,4), cuda.data(:,4)]);
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

%%%  plot some data

%subplot(3,1,1)
%plot(up_time(:,1), 'b');
%hold on
%plot(up_time(:,2), 'g');
%hold off
%title('upload time');
%xlabel('index');
%ylabel('time (s)');
%legend('CPU', 'GPU');

%subplot(3,1,2)
%plot(solve_time(:,1), 'b');
%hold on
%plot(solve_time(:,2), 'g');
%hold off
%title('solve time');
%xlabel('index');
%ylabel('time (s)');
%legend('CPU', 'GPU');

%subplot(3,1,3)
%plot(iter(:,1), 'b');
%hold on
%plot(iter(:,2), 'g');
%hold off
%title('iter');
%xlabel('index');
%ylabel('number of iterations');
%legend('CPU', 'GPU');

%% remove outliers

blas_keep1 = true_user < 250;
cuda_keep1 = true_user < 250;

%%% plot SCI

%subplot(3,1,1)
%plot(SCI(:,1), 'b');
%hold on
%plot(SCI(:,2), 'g');
%hold off
%title('SCI');
%xlabel('index');
%ylabel('SCI');
%legend('CPU', 'GPU');

%%%  threshold based on SCI

%sci_threshold = 0.17;

%blas_keep2 = SCI(:,1) > sci_threshold;
%cuda_keep2 = SCI(:,2) > sci_threshold;

blas_rank = trueUserRank(blas_keep1 & blas_keep2,1);
cuda_rank = trueUserRank(cuda_keep1 & cuda_keep2,2);

%subplot(4,1,1)
%plot(SCI(blas_keep1 & blas_keep2,1), 'b');
%title('SCI');
%xlabel('index');
%ylabel('SCI');
%legend('CPU');
%xlim([1 size(blas_rank,1)]);

%subplot(4,1,2)
%plot(blas_rank);
correct = sum(blas_rank == 1);
rejected = sum(blas_keep2 == 0);
%title(['BLAS accuracy: ' num2str(correct/numel(blas_rank)) ' rejected: ' num2str(rejected/numel(blas_keep1))]);
%xlabel('index');
%ylabel('rank of true user');
%xlim([1 size(blas_rank,1)]);

%subplot(4,1,3)
%plot(SCI(cuda_keep1 & cuda_keep2,2), 'g');
%title('SCI');
%xlabel('index');
%ylabel('SCI');
%legend('GPU');
%xlim([1 size(cuda_rank,1)]);

%subplot(4,1,4)
%plot(cuda_rank);
correct = sum(cuda_rank == 1);
rejected = sum(cuda_keep2 == 0);
%title(['CUDA accuracy: ' num2str(correct/numel(cuda_rank)) ' rejected: ' num2str(rejected/numel(cuda_keep1))]);
%xlabel('index');
%ylabel('rank of true user');
%xlim([1 size(cuda_rank,1)]);

%%% plot residual

%subplot(2,1,1);
blas_residuals = users_residuals{1}(:,1);
%plot(blas_residuals);
%subplot(2,1,2);
cuda_residuals = users_residuals{2}(:,1);
%plot(cuda_residuals)

%%% threshold based on residual value

%residual_threshold = 0.67;

%blas_keep3 = users_residuals{1}(:,1) < residual_threshold;
%cuda_keep3 = users_residuals{2}(:,1) < residual_threshold;

blas_rank = trueUserRank(blas_keep1 & blas_keep3,1);
cuda_rank = trueUserRank(cuda_keep1 & cuda_keep3,2);

%subplot(4,1,1)
%plot(users_residuals{1}(blas_keep1 & blas_keep3,1), 'b');
%title('Residual');
%xlabel('index');
%ylabel('Residual');
%legend('CPU');
%xlim([1 size(blas_rank,1)]);

%subplot(4,1,2)
%plot(blas_rank);
correct = sum(blas_rank == 1);
rejected = sum(blas_keep3 == 0);
%title(['BLAS accuracy: ' num2str(correct/numel(blas_rank)) ' rejected: ' num2str(rejected/numel(blas_keep1))]);
%xlabel('index');
%ylabel('rank of true user');
%xlim([1 size(blas_rank,1)]);

%subplot(4,1,3)
%plot(users_residuals{2}(cuda_keep1 & cuda_keep2,1), 'g');
%title('Residual');
%xlabel('index');
%ylabel('Residual');
%legend('GPU');
%xlim([1 size(cuda_rank,1)]);

%subplot(4,1,4)
%plot(cuda_rank);
correct = sum(cuda_rank == 1);
rejected = sum(cuda_keep3 == 0);
%title(['CUDA accuracy: ' num2str(correct/numel(cuda_rank)) ' rejected: ' num2str(rejected/numel(cuda_keep1))]);
%xlabel('index');
%ylabel('rank of true user');
%xlim([1 size(cuda_rank,1)]);

%%% threshold based on residual and SCI value

%%sci_threshold = 0.07;
%%residual_threshold = 2;
%sci_threshold = 0;
%residual_threshold = 1;

%blas_keep1 = true_user < 250;
%cuda_keep1 = true_user < 250;
blas_keep1 = true_user <= 250;
cuda_keep1 = true_user <= 250;

%blas_keep2 = SCI(:,1) > sci_threshold;
%cuda_keep2 = SCI(:,2) > sci_threshold;
%blas_keep3 = users_residuals{1}(:,1) < residual_threshold;
%cuda_keep3 = users_residuals{2}(:,1) < residual_threshold;

blas_rank = trueUserRank(blas_keep1 & blas_keep2 & blas_keep3,1);
cuda_rank = trueUserRank(cuda_keep1 & cuda_keep2 & cuda_keep3,2);

%subplot(6,1,1)
%plot(SCI(blas_keep1 & blas_keep2 & blas_keep3,1), 'b');
%title('SCI');
%%xlabel('index');
%ylabel('SCI');
%xlim([1 size(blas_rank,1)]);
%ylim([0 0.5]);

%subplot(6,1,2)
%plot(users_residuals{1}(blas_keep1 & blas_keep2 & blas_keep3,1), 'b');
%title('Residual');
%%xlabel('index');
%ylabel('Residual');
%xlim([1 size(blas_rank,1)]);
%ylim([0.5 1]);

%subplot(6,1,3)
%plot(blas_rank);
correct = sum(blas_rank == 1);
rejected = sum(or(blas_keep2 == 0, blas_keep3 == 0));
%title(['BLAS accuracy: ' num2str(correct/numel(blas_rank)) ' rejected: ' num2str(rejected/numel(blas_keep1))]);
%%xlabel('index');
%ylabel('rank of true user');
%legend('CPU');
%xlim([1 size(blas_rank,1)]);
blasAc = correct/numel(blas_rank);

%subplot(6,1,4)
%plot(SCI(cuda_keep1 & cuda_keep2 & cuda_keep3,2), 'g');
%title('SCI');
%%xlabel('index');
%ylabel('SCI');
%xlim([1 size(cuda_rank,1)]);
%ylim([0 0.5]);

%subplot(6,1,5)
%plot(users_residuals{2}(cuda_keep1 & cuda_keep2 & cuda_keep3,1), 'g');
%title('Residual');
%%xlabel('index');
%ylabel('Residual');
%xlim([1 size(cuda_rank,1)]);
%ylim([0.5 1]);

%subplot(6,1,6)
%plot(cuda_rank);
correct = sum(cuda_rank == 1);
rejected = sum(or(cuda_keep2 == 0, cuda_keep3 == 0));
%title(['CUDA accuracy: ' num2str(correct/numel(cuda_rank)) ' rejected: ' num2str(rejected/numel(cuda_keep1))]);
%%xlabel('index');
%ylabel('rank of true user');
%legend('GPU');
%xlim([1 size(cuda_rank,1)]);
cudaAc = correct/numel(cuda_rank);

%if saveQ
    %saveas(gcf, ['results_' num2str(imsize)], 'jpg');
%end
