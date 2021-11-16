function [data,all_data] = get_axiom_data(settings)

%% read in data
list = dir(['.\axiom_data\' settings.grant_no '*.xlsx']);
all_data = readtable(['.\axiom_data\' list.name]);
del_idx = find(isnan(all_data.ProjectName));
all_data(del_idx,:) = [];

%% select relevant columns
data = all_data(:,{'AccountedAmount','TaskNumber','TransactionDate'});

% %% get all task categories
% categories = unique(data.TaskNumber);