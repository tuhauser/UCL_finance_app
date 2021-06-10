function report_all_expenses(all_data,settings)


%% select only last N months
startdat = datenum(datetime('today','Format','yyyy-MM-dd') - calmonths(settings.last_N_months));
all_data = all_data(find(datenum(all_data.TransactionDate)>=startdat),:);

%% create report for each category separately
fileID = fopen([settings.report_dir datestr(datetime('today'),'yyyy_mm') '_' settings.grant_name{:} '_detailedReport.txt'],'w');
for c = 1:length(settings.categories_desc)
    fprintf(fileID,[settings.categories_desc{c} ' (' settings.categories{c} '):\n']);
    
    % find entries
    tmp_idx = find(strcmp(all_data.TaskNumber,settings.categories{c}));
    if isempty(tmp_idx)
        fprintf(fileID,'N/A\n\n');
    else
        tmp_data = all_data(tmp_idx,:);
        
        % print each expense
        tmp_data = sortrows(tmp_data,'TransactionDate');
        for i = 1:height(tmp_data)
            if strcmp(settings.categories{c},'S-ACA')
                fprintf(fileID,[datestr(tmp_data.TransactionDate(i)) '\t' tmp_data.CurrencyCode{i} ' ' num2str(tmp_data.AccountedAmount(i),'%.2f') '\t' tmp_data.NominalName{i} '\t' tmp_data.TransactionDescription{i} '\t' tmp_data.JournalNo_{i} '\n']);
                
            else
                fprintf(fileID,[datestr(tmp_data.TransactionDate(i)) '\t' tmp_data.CurrencyCode{i} ' ' num2str(tmp_data.AccountedAmount(i),'%.2f') '\t' tmp_data.NominalName{i} '\t' tmp_data.TransactionDescription{i} '\n']);
            end
        end
        fprintf(fileID,'\n\n');
    end
end         
fclose(fileID);