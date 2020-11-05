function cost = add_cost(settings,cost_sett)

if nargin < 2
    cost_sett = [];
    cost_sett.cost_name = 'salary TUH';
    cost_sett.cost_type = 'S-ACA';
    cost_sett.cost_pM = 5000;
    cost_sett.cost_start = [];
    cost_sett.cost_end = [];
end


%% add details if midding
if isempty(cost_sett.cost_start)
    disp([cost_sett.cost_name ': no starting date for costs defined, assuming next month.'])
    cost_sett.cost_start = datetime('today','Format','yyyy-MM')+calmonths(1);
end
if isempty(cost_sett.cost_end)
    disp([cost_sett.cost_name ': no end date for costs defined, assuming grant end.'])
    cost_sett.cost_end = settings.endDate;
end

%% create ne cost structure
cost = [];
cost.name = cost_sett.cost_name;
cost.type = cost_sett.cost_type;
idx_strt = find(datenum(settings.periods)<=datenum(cost_sett.cost_start),1,'last');
idx_end = find(datenum(settings.periods)<=datenum(cost_sett.cost_end),1,'last');
cost.costs = zeros(1,length(settings.periods));
cost.costs(idx_strt:idx_end) = cost_sett.cost_pM;