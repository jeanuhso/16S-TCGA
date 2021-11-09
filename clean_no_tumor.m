%% Removing bacterial taxa rows of zeros (sum = 0)
%% Load data
no_tumor = readtable('CLEAN_OTU_TUMOR_ONLY.xlsx');

%% Remove rows where column 254 = 0
no_tumor(no_tumor{:,254} == 0,:) = [];

%% Save new file
writetable(no_tumor,'no_tumor.csv')
