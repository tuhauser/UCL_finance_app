function get_grant_keydata(filename)

if ~nargin
    filename = '.\axiom_data\axiom_grant_overview.xlsx';
end


%% load data
data = readtable(filename);
del_idx = find(isnan(data.Project));
data(del_idx,:) = [];

%% aggregate per grant and save
grants = unique(data.Project);
for g = 1:length(grants)
    settings = [];
    settings.grant_no = int2str(grants(g));
    settings.grant_name = data.AwardName(find(data.Project==grants(g),1,'first'));
    settings.categories = data.TaskNumber(find(data.Project==grants(g)));
    settings.categories_desc = data.TaskName(find(data.Project==grants(g)));
    settings.startDate = data.ProjectStart(find(data.Project==grants(g),1,'first'));
    settings.endDate = data.ProjectEnd(find(data.Project==grants(g),1,'first'));
    settings.budget = data.Research_DTABudget(find(data.Project==grants(g)));
    tmp = settings.startDate:calmonths(1):settings.endDate;
    settings.periods = datetime(tmp,'Format','yyyy-MM');
    save(['grant_' settings.grant_name{:} '.mat'],'settings')
end