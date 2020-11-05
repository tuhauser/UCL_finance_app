function run_all_grants()

%% get grant settings
list = dir('grant_*.mat');

%% loop through grants
for g = 1:length(list)
    close all; clc; clear settings
    
    %% load grant
    load(list(g).name)
    settings.verbose = 1;
    settings.report_dir = 'D:\myDocuments\work\MPC_admin\Finance\overviews\';
    settings.save_plot = 1;
    
    %% load data
    [data,all_data] = get_axiom_data(settings);
    
    %% aggregate (and display) data
    [report, total] =  get_report(data, settings);
    
    %%
    pause()
end