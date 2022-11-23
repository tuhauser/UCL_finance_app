function [data,all_data,settings] = get_axiom_data(settings)

%% read in data
list = dir(['.\axiom_data\' settings.grant_no '*.xlsx']);
all_data = readtable(['.\axiom_data\' list.name]);
del_idx = find(isnan(all_data.ProjectName));
all_data(del_idx,:) = [];

if ~strcmp(settings.AwardType,'Sponsored Research')
	% get subcategories 
	settings.subcategories = unique(all_data.ExpenditureType);

	for k=1:length(settings.subcategories)
		settings.subcategories_desc(k) = unique(all_data.ExpenditureTypeName(all_data.ExpenditureType==settings.subcategories(k))); 
		settings.subcategories_desc{k} = ['X_' regexprep(settings.subcategories_desc{k},'[ &/-]*','')]; 
	end

	% get total on grant 
	totals = readtable(['./axiom_data/ProjectBalances.xlsx']); % income & expenditures -> project report - project balances dann im filter unter project names alle projekte highlighten 
	idx=strcmp(settings.grant_no,totals.Project);
	settings.budget = totals.C_Fwd(idx);
end

%% select relevant columns
data = all_data(:,{'AccountedAmount','TaskNumber','TransactionDate','ExpenditureType','ExpenditureTypeName'});

% %% select relevant columns
% data = all_data(:,{'AccountedAmount','TaskNumber','TransactionDate'});

% %% get all task categories
% categories = unique(data.TaskNumber);