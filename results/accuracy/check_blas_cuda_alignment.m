table = zeros(50,1);
for x=1:size(SCI,1)
    
    a2 = users_names{1}(x,:);
    b2 = users_names{2}(x,:);
    d1 = intersect(a2,b2);
    d2 = numel(d1);
    table(d2) = table(d2) + 1;
    
end

plot(table ./ size(SCI,1), '.-')
xlabel('Number of users');
ylabel('Percent occurence');
title('Number of users in common in CUDA and BLAS alignment');