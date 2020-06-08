function [prederrs,trackerrs,costs] = analyse(baseline_results,wnn_results,prederrs,trackerrs,costs)
%%
% baseline_results: 804X102 sim_data (704X102 for sigmoid)
% wnn_results: 804X102 sim_data (704X102 for sigmoid

% plots trajectory tracking using plotcomparisons 
% plots trajectory tracking error as bar plot per DOF
% plots sum of costs over alll trajectories
%%
prederrs = [ prederrs; plot_statedotprederror(baseline_results,wnn_results)];
trackerrs =[trackerrs;plot_trackerror(baseline_results,wnn_results)];
plot_historycomparison(baseline_results,wnn_results);
costs = [costs;getcosts(baseline_results,wnn_results)];

end