% Stepwise temporal autocorrelation script
% Study: Long axis voxel patterns
% Iva Brunec & Buddhika Bellana, 2017
%%%% This script correlates each TR to each subsequent one for data split
%%%% by axis position and hemisphere. 

%%
clear;

% set wd
cd('\Long_Axis_Voxel_Patterns')

% read in .txt file where each row is a TR & each column is a voxel
voxel_data = dlmread('example_data.txt','');

% standardize data
voxel_data_z = zscore(voxel_data,0,1);

% autocorrelation loop
% takes each TR and correlates it to subsequent TR
for i = 1:length(voxel_data_z)-1
    
    temp = corrcoef(voxel_data_z(i,:),voxel_data_z(i+1,:));
    cor(i) = temp(2);

end
% to adjust the lag at which autocorrelation is calculated, 
%simply adjust i+1 to i+n

cor = cor';
% this produces a column with n-1 rows compared to raw data.

fz_cor = .5*((log(1+cor)/log(exp(1)))-(log(1-cor)/log(exp(1)))); %Apply Fisher-Z transform to cor

% visually inspect the output
plot(fz_cor)

%% Multiple runs
%%%% If you have multiple runs concatenated, make sure to skip the boundary
%%%% between two runs to avoid spurious cross-run correlations:
for i = 1:length(run_data)-1
    
    if run_number(i)== run_number(i+1)
    temp = corrcoef(voxel_data_z(i,:),voxel_data_z(i+1,:));
    cor{i} = temp(2);
    
    else 
        i=i+2;
    end
end