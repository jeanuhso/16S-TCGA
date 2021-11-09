%% Load data

if ~exist('knight_parse','var')
    knight_parse = readcell('knight_raw_data.xlsx');
    knight_parse = knight_parse';
end

%% Create table

column_names = [names,knight_parse(1,2:end)];
variable_types = [repmat({'string'}, 1, n_names), repmat({'double'}, 1, size(knight_parse(1,2:end),2))];
knight_parse_tbl = table('Size',[size(knight_parse,1)-1, length(variable_types)],'VariableTypes',...
    variable_types,'VariableNames',column_names);

%% Insert nums

nums = cell2mat(knight_parse(2:end,2:end));
knight_parse_tbl{:,n_names+1:end} = nums;
%% Split names

for r = 1:size(nums,1)
    str = knight_parse{r+1,1};
    split = strsplit(str,'.');
    
    for n = 1:n_names
        match = regexp(split,[markers{n},'\w*\w'],'match');
        match = char([match{:}]);
        if isempty(match)
            knight_parse_tbl{r,n} = string(['Unknown ', names{n}]);
        else
            knight_parse_tbl{r,n} = string(match(4:end));
        end
    end
    
end

%% Save new file
writetable(knight_parse_tbl,'knight_parse_tbl.csv')
writetable(knight_parse_tbl(1:200,:),'knight_parse_tbl_preview.csv')