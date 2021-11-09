%% Download/load data
% Comment out if data is already loaded 
wd = '/Users/jeanuhso/Desktop/Research/MATLAB';
urlwrite(['http://ftp.microbio.me/pub/cancer_microbiome_analysis/TCGA/', ...
    'Kraken/Kraken-TCGA-Voom-SNM-Plate-Center-Filtering-Data.csv'],[wd,'/plated.csv'])

plated = readcell('plated.csv');
knight = readcell('raw_pruned.csv');

%% Process headers

% Headers for knight and plated data
headers1 = knight(1,2:end);
headers2 = plated(1,2:end);

processed_headers1 = cell(length(headers1), n_names);

% For each knight header
for i = 1:length(headers1)
    
    % Get the string
    str = headers1{i};

    % For each taxonomic group
    for n = 1:n_names
        
        % See if there are any matches for that group
        % (regexp finds strings that begin with the marker for that
        % taxonomic group and only contain letters or numbers)
        match = regexp(str,[markers{n},'[a-zA-Z-0-9]*[a-zA-Z-0-9]'],'match');
        match = char([match{:}]);
        
        % If no match found, say that the taxonomic group is unknown
        if isempty(match)
            processed_headers1{i,n} = ['Unknown ', names{n}];
            
        % If a match is found, enter that match into the column
        % corresponding to the taxonomic group
        else
            processed_headers1{i,n} = match(4:end);
        end
    end
    
end

processed_headers2 = cell(length(headers2), n_names);

% For each plated header
for i = 1:length(headers2)
    
    % Get the string
    str = headers2{i};

    % For each taxonomic group
    for n = 1:n_names
        
        % See if there are any matches for that group
        % (regexp finds strings that begin with the marker for that
        % taxonomic group and only contain letters or numbers)
        match = regexp(str,[markers{n},'[a-zA-Z-0-9]*[a-zA-Z-0-9]'],'match');
        match = char([match{:}]);
        
        % If no match found, say that the taxonomic group is unknown
        if isempty(match)
            processed_headers2{i,n} = ['Unknown ', names{n}];
            
        % If a match is found, enter that match into the column
        % corresponding to the taxonomic group
        else
            processed_headers2{i,n} = match(4:end);
        end
       
    end
end

%% Get rid of non-bacteria

% Find index of rows where the domain is bacteria
good_idx1 = ismember(processed_headers1(:,1),'Bacteria');
bad_idx1 = ~good_idx1;

% Remove rows where domain is not bacteria
processed_headers1(bad_idx1,:) = [];

% Find index of rows where the domain is bacteria
good_idx2 = ismember(processed_headers2(:,1),'Bacteria');
bad_idx2 = ~good_idx2;

% Remove rows where domain is not bacteria
processed_headers2(bad_idx2,:) = [];

% Re-join headers so they are one string, not split into separate cells
joined_headers1 = cell(size(processed_headers1,1), 1);
for i = 1:size(processed_headers1,1)
    joined_headers1{i} = strjoin(processed_headers1(i,:));
end

joined_headers2 = cell(size(processed_headers2,1), 1);
for i = 1:size(processed_headers2,1)
    joined_headers2{i} = strjoin(processed_headers2(i,:));
end

%% Find intersection of headers
[overlap, idx1, idx2] = intersect(joined_headers1, joined_headers2);
idx3 = find(good_idx1);
knight_only_overlaps = knight;
knight_only_overlaps = knight_only_overlaps(:, idx3(idx1) + 1);

% Save file
writecell(knight_only_overlaps, 'knight_only_overlaps.csv')

%% Transpose knight table

% Transpose
temp = knight_only_overlaps;
temp = temp';

% Get the "split names" from knight
split_names = processed_headers1(idx1,:);

n_rows = length(idx1);
n_cols = n_names + size(temp,2) - 1;

% Create empty table
knight_overlap_transpose = table('Size',[n_rows, n_cols],'VariableTypes',...
    [repmat({'string'}, 1, n_names), repmat({'double'}, 1, size(temp,2) - 1)], ...
    'VariableNames',[names, knight(2:end,1)']);

% Fill in names
knight_overlap_transpose{:,1:n_names} = split_names;

% Fill in numerical values
knight_overlap_transpose{:,length(names) + 1:end} = cell2mat(temp(:,2:end));

% Save file
writetable(knight_overlap_transpose,'knight_overlap_transpose.csv')