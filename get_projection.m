function [report, total] = get_projection(data, settings, costs)

%% pre-requirements
categories = settings.categories;
periods = settings.periods;
report = [];

%% find descriptions for categories
UCL = load('UCL_categories.mat');
cat_desc = [];
for c = 1:length(categories)
    idx = find(strcmp(UCL.categories.type,categories{c}));
    cat_desc{c} = UCL.categories.name{idx};
end

%% aggregate per period
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

org_report = report;    % prior to adding costs

%% add future costs
for c = 1:length(costs)
    report.(strrep(costs{c}.type,'-','_')) = nansum([report.(strrep(costs{c}.type,'-','_')); costs{c}.costs],1);
end

%% calculate totals
total = [];
for c = 1:length(categories)
    total.(strrep(categories{c},'-','_')) = nansum(report.(strrep(categories{c},'-','_')));
end

if settings.verbose
    diary([settings.report_dir datestr(datetime('today'),'yyyy_mm') '_' settings.grant_name{:} '_projection.log'])
    fprintf(['PROJECTIONS: ' settings.grant_name{:} '\n'])
    for c = 1:length(categories)
        fprintf([cat_desc{c} ' (' categories{c} '):\n'])
        fprintf(['\t projected expenditure: £' num2str(total.(strrep(categories{c},'-','_')),'%010.2f') '\n'])
        fprintf(['\t budget: \t\t\t\t £' num2str(settings.budget(c),'%010.2f') '\n'])
        fprintf(['\t remaining: \t\t\t £' num2str(settings.budget(c)-total.(strrep(categories{c},'-','_')),'%010.2f') '\n'])
        fprintf('\n')
    end
    diary off
end

%% show report
if settings.verbose
    
    % cumulative plot
    figure('Color','w');
    set(gcf,'Unit','normalized','OuterPosition',[0 0 .5 .5]);
   set(gca,'FontName','Arial','FontSize',12)
    hold on
    % current expenditures
    cur_periods = periods(1:find(datenum(periods)<=datenum(datetime('today')),1,'last'));
    for c = 1:length(categories)
        tmp_dat = cumsum(org_report.(strrep(categories{c},'-','_'))./1000,'omitnan');
        p = plot(cur_periods,tmp_dat(1:length(cur_periods)),'linewidth',3);
        col(c,:) = p.Color;
    end
    % projected expenditures
    for c = 1:length(categories)
        p = plot(periods,cumsum(report.(strrep(categories{c},'-','_'))./1000,'omitnan'),'color',[col(c,:) .2],'linewidth',3);
    end
    % total budget
    for c = 1:length(categories)
        plot(periods(end),settings.budget(c)/1000,'o','MarkerFaceColor',col(c,:),'MarkerEdgeColor',col(c,:))
    end
    legend(cat_desc,'Location','northwest')
%     set(gca,'XTick',periods(1):calmonths(1):periods(end))
    ylabel('cumulative expenditure in £1000','FontName','Arial','Fontweight','bold','FontSize',12);
    xlim([periods(1) periods(end)])
    t = title(settings.grant_name);
    set(t,'Interpreter','none')
    if settings.save_plot
        export_fig([settings.report_dir datestr(datetime('today'),'yyyy_mm') '_' settings.grant_name{:} '_projections.png'],'-nocrop','-r100');
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
%     ylabel('monthly expenditure in £1000','FontName','Arial','Fontweight','bold','FontSize',12);
%     t = title(settings.grant_name)
%     set(t,'Interpreter','none')
%     xlim([periods(1) datetime('today')])
end
