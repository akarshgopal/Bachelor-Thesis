function [bnncosts] = getcosts(baseline_results,wnn_results)
%%
% baseline_results: sim_data 
% wnn_results:sim_data

% returns of precentage change in total cost wrt baseline
%%
bcosts = sum(baseline_results(:,102));
nncosts = sum(wnn_results(:,102));

%percentage change in costs
bnncosts = (nncosts - bcosts)*100/bcosts;

% If costs are required separately
%bnncosts = [bcosts;nncosts];

end