function [] = plot_historycomparison(baseline_results,wnn_results)
%%
% baseline_results: 804X102 sim_data (704X102 for sigmoid)
% wnn_results: 804X102 sim_data (704X102 for sigmoid

% plots trajectory tracking using plotcomparisons 
% plots trajectory tracking error as bar plot per DOF
% plots sum of costs over alll trajectories
%%

xbaselineHistory = baseline_results(:,33:44);
ubaselineHistory = baseline_results(:,45:52);
yref_History = wnn_results(:,1:12);
x_History =wnn_results(:,33:44);
u_History  = wnn_results(:,45:52);

time = 0:0.1:0.1*length(x_History);

plotcomparisons(time(1:end-1),xbaselineHistory,x_History,yref_History,ubaselineHistory,u_History);