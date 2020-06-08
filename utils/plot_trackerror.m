function [tmses] = plot_trackerror(baseline_results,wnn_results)
%%
% baseline_results: 804X102 sim_data (704X102 for sigmoid)
% wnn_results: 804X102 sim_data (704X102 for sigmoid

% plots trajectory tracking error as bar plot per DOF, and returns
% percentage change in tracking MSE
%%

xbaselineHistory = baseline_results(1:201,33:44);
yref_History = wnn_results(1:201,1:12);
x_History =wnn_results(1:201,33:44);


trackerr = ((x_History(:,1:6) - yref_History(:,1:6)).^2);
baseerr = ((xbaselineHistory(:,1:6) - yref_History(:,1:6)).^2);

figure;
tmse = mean(trackerr,1);
bmse = mean(baseerr,1);
bar([bmse;tmse]');

% get percentage change in tracking MSE
tmses =sum(tmse-bmse)*100/sum(bmse);

%if tracking MSEs are needed separately
%tmses = [bmse;tmse];


title('Tracking Error');
legend('baseline','with NN','Location','northwest');
xlabel('state variable');
ylabel('units (m) or (rad)');
end