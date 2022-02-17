function run_all_grants()
fn = fileparts(pwd);
addpath([fn(1) ':\myDocuments\work\Tools\spm\'])
addpath(genpath([fn(1) ':\myDocuments\work\Projects\gen_funct\']))

%% get grant settings
list = dir('grant_*.mat');
fn = fileparts(pwd);

%% loop through grants
for g = 1:length(list)
    close all; clc; clear settings
    disp(list(g).name)
    
    %% load grant
    load(list(g).name)
    settings.verbose = 1;
    settings.report_dir = [fn(1) ':\myDocuments\work\MPC_admin\Finance\overviews\' datestr(datetime('today'),'yyyy_mm') '\'];
    settings.save_plot = 1;
    
    %% load data
    [data,all_data] = get_axiom_data(settings);

    %% get detailed data
    settings.last_N_months = 2;
    report_all_expenses(all_data,settings);
    
    %% aggregate (and display) data
    [report, total] =  get_report(data, settings);
    
    %%
%     pause()
end