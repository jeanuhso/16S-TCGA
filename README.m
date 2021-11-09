%% Define taxonomic groups
% These will be used for column headers
names = {'Domain','Phylum','Class','Order','Family','Genus', 'Species'};

% These will be used for parsing strings (using regexp)
markers = cellfun(@(x) [x(1),'__'], lower(names) ,'UniformOutput',false);
markers{1} = 'k__';

%% Process strauss data

strauss_process;

%% Compare strauss and knight

compare_strauss_knight;

%% Process knight data

knight_process;

%% Parse and transpose knight data to look like straussman

knight_transpose_split;

%% Create no tumor table for straussman

clean_no_tumor;

%% Find knight measures

knight_readcounts_mean_sd_etc;

%% Find strauss_measures

straussman_readcounts_mean_sd_etc;

%% Find knight unknown percentages

knight_otu_unknowns;

%% Find strauss unknown percentages

straussman_otu_unknowns;

%% Process plated data and transpose otu data

process_plated_knight;
