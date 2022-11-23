function [report, total] =  get_report(data, settings)

%% pre-requirements
categories = settings.categories;
periods = settings.periods;
report = [];

issponsoredresearch = strcmp(settings.AwardType,'Sponsored Research');

if ~issponsoredresearch
	subcategories = settings.subcategories;
	if ~isempty(subcategories); subcategories_desc = settings.subcategories_desc; end
end

%% find descriptions for categories
UCL = load('UCL_categories.mat');
cat_desc = [];
for c = 1:length(categories)
    idx = find(strcmp(UCL.categories.type,categories{c}));
    cat_desc{c} = UCL.categories.name{idx};
end

%% aggregate per period
if issponsoredresearch
    for c = 1:length(categories)
        for p = 1:length(periods)
            idx = find(periods(p)+calmonths(1)>data.TransactionDate & data.TransactionDate>=periods(p) & strcmp(data.TaskNumber,categories{c}));
            if isempty(idx)
                report.(strrep(categories{c},'-','_'))(p) = nan();
            else
                report.(strrep(categories{c},'-','_'))(p) = sum(data.AccountedAmount(idx));
            end
        end
    end
else
    for c = 1:length(subcategories)
        for p = 1:length(periods)
            idx = find(periods(p)+calmonths(1)>data.TransactionDate & data.TransactionDate>=periods(p) & data.ExpenditureType==subcategories(c));
            if isempty(idx)
                report.(subcategories_desc{c})(p) = nan();
            else
                report.(subcategories_desc{c})(p) = sum(data.AccountedAmount(idx));
            end
        end
    end
end

%% calculate totals
total = [];
if issponsoredresearch
	for c = 1:length(categories)
		 total.(strrep(categories{c},'-','_')) = nansum(report.(strrep(categories{c},'-','_')));
	end
else
	for c=1:length(settings.subcategories)
		 total.(subcategories_desc{c}) = nansum(report.(subcategories_desc{c}));
	end
end

if settings.verbose
   tot_bud = 0; tot_spent = 0;
   diary([settings.report_dir datestr(datetime('today'),'yyyy_mm') '_' settings.grant_name{:} '.log'])
   fprintf([settings.grant_name{:} '\n'])
	if issponsoredresearch
		 for c = 1:length(categories)
			  fprintf([cat_desc{c} ' (' categories{c} '):\n'])
			  fprintf(['\t current expenditure: \t £' num2str(total.(strrep(categories{c},'-','_')),'%010.2f') '\n'])
			  fprintf(['\t budget: \t\t\t\t £' num2str(settings.budget(c),'%010.2f') '\n'])
			  fprintf(['\t remaining: \t\t\t £' num2str(settings.budget(c)-total.(strrep(categories{c},'-','_')),'%010.2f') '\n'])
			  fprintf('\n')
			  tot_bud = tot_bud + settings.budget(c); tot_spent = tot_spent + total.(strrep(categories{c},'-','_'));
		 end
	else 
		 for c = 1:length(subcategories)
			  fprintf([subcategories_desc{c} ':'])
			  fprintf(['\t current expenditure: \t £' num2str(total.(subcategories_desc{c}),'%010.2f') '\n'])
		 end
		 tot_bud = settings.budget; 
	 end
    fprintf(['total expenditure: \t £' num2str(tot_spent,'%010.2f') '\n'])
    fprintf(['total budget: \t\t\t £' num2str(tot_bud,'%010.2f') '\n'])
    fprintf(['remaining: \t\t\t £' num2str(tot_bud - tot_spent,'%010.2f') '\n'])
    fprintf('\n')
    diary off
end

%% show report
if settings.verbose
    
    % cumulative plot
    figure('Color','w');
    set(gcf,'Unit','normalized','OuterPosition',[0 0 .5 .5]);
    set(gca,'FontName','Arial','FontSize',12)
    hold on
	 if issponsoredresearch
		 % expenditures
		 for c = 1:length(categories)
			  p = plot(periods,cumsum(report.(strrep(categories{c},'-','_'))./1000,'omitnan'),'linewidth',3);
			  col(c,:) = p.Color;
		 end
		 % total budget
		 for c = 1:length(categories)
			  plot(datetime('today'),settings.budget(c)/1000,'o','MarkerFaceColor',col(c,:),'MarkerEdgeColor',col(c,:))
		 end
    	legend(cat_desc,'Location','northwest')
	 else
		 % expenditures
		 tot_spent = zeros(1,length(periods));
		 for c = 1:length(subcategories)
			 if ~any(subcategories(c)==[14077 33002])
			  spent = cumsum(report.(subcategories_desc{c})./1000,'omitnan'); 
			  tot_spent = tot_spent + spent; 
			  p = plot(periods,spent,'linewidth',3);
			  col(c,:) = p.Color;
			 end
		 end
		 % total budget
		 plot(datetime('today'),settings.budget/1000,'r+'); 
		 plot(periods,tot_spent,'k-','linewidth',4); 
		 leg = subcategories_desc(2:end); leg{end+1} = 'Total Budget'; leg{end+1} = 'Total spent';
    	legend(leg,'Location','northwest','Interpreter','none')
	 end
    set(gca,'XTick',periods(1):calmonths(1):datetime('today'),'xticklabelrotation',45); 
    ylabel('cumulative expenditure in Â£1000','FontName','Arial','Fontweight','bold','FontSize',12);
    xlim([datetime(2019,1,1) datetime('today')])
    t = title(settings.grant_name);
    set(t,'Interpreter','none')
    if settings.save_plot
        export_fig([settings.report_dir datestr(datetime('today'),'yyyy_mm') '_' settings.grant_name{:} '.png'],'-nocrop','-r100')
    end
    
    
%     % period-based plot plot
%     figure('Color','w');
%     set(gcf,'Unit','normalized','OuterPosition',[0 0 1 1]);
%    set(gca,'FontName','Arial','FontSize',12)
%     hold on
%     for c = 1:length(categories)
%         tmp = report.(strrep(categories{c},'-','_'))./1000;
%         tmp(isnan(tmp)) = 0;
%         plot(periods,tmp,'linewidth',3)
%     end
%     legend(categories,'Location','northwest')
%     set(gca,'XTick',periods(1):calmonths(1):datetime('today'))
%     ylabel('monthly expenditure in Â£1000','FontName','Arial','Fontweight','bold','FontSize',12);
%     t = title(settings.grant_name)
%     set(t,'Interpreter','none')
%     xlim([periods(1) datetime('today')])
end

