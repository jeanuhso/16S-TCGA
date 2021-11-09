%% Create dummy data structure to work with
temp = table2cell(knight_overlap_transpose);
remove = find(sum(cell2mat(temp(:,n_names+1:end)),2)==0);
temp(remove,:) = [];

%% Iterate over taxonomic groups
% For each taxonomic group
for n = 1:n_names
    
    % Find unique classes within taxonomic group
    unique_names = unique(cellstr(temp(:,n)));
    unique_names(ismissing(unique_names)) = [];
    num_unique = length(unique_names);
    
    % Create empty table
    knight_overlap_measures = table('Size',[num_unique,8],'VariableTypes',...
        ['string', repmat({'double'}, 1, n_names)],'VariableNames', [names(n), measures]);
    
    % For each class
    for u = 1:num_unique
        
        % Index of rows with class
        idx = find(strcmp(unique_names(u), cellstr(temp(:,n))));
        
        % For each row with that class
        sums = zeros(1,length(idx));
        for i = 1:length(idx)
            
            % Record the sum of values for that row
            sums(i) = sum(cell2mat(temp(idx(i),n_names+1:end)));
        end
        
        % Record measures based on these sums
        knight_overlap_measures{u,1} = unique_names(u);
        knight_overlap_measures{u,2} = length(idx);
        knight_overlap_measures{u,3} = sum(sums);
        knight_overlap_measures{u,4} = mean(sums);
        knight_overlap_measures{u,5} = std(sums);
        knight_overlap_measures{u,6} = median(sums);
        knight_overlap_measures{u,7} = max(sums);
        knight_overlap_measures{u,8} = min(sums);
    end
    
    % Sort rows in descending order
    knight_overlap_measures = sortrows(knight_overlap_measures,3,'descend');
    
    % Save table
    writetable(knight_overlap_measures,['knight_overlap_measures_', lower(names{n}), '.csv'])
end