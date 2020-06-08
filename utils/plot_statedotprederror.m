function [mses] = plot_statedotprederror(baseline_results,wnn_results)
%%
% baseline_results: 804X102 sim_data (704X102 for sigmoid)
% wnn_results: 804X102 sim_data (704X102 for sigmoid

% plots prediction error in state derivative as bar plots per DOF, and
% returns percentage change in prediction error
%%

xdot_History = wnn_results(1:201,65:76);
xdotpred_History = wnn_results(1:201,77:88);
xdotnnpred_History = wnn_results(1:201,89:100);

figure;
errs1 = ((xdot_History(:,7:9) - xdotpred_History(:,7:9)).^2);
errs2 = ((xdot_History(:,7:9) - xdotpred_History(:,7:9)-xdotnnpred_History(:,7:9)).^2);
mse1 = mean(errs1,1);
mse2 = mean(errs2,1);
bar([mse1;mse2]');

%get percentage change in linear acceleration prediction error
mses = sum(mse2-mse1)*100/sum(mse1);

%if prediction errors are needed separately
%mses = [mse1;mse2];

% Plot the acceleration prediction error

title('Linear Acceleration Prediction Error ');
legend('baseline','with NN','Location','northwest');
xlabel('direction');
ylabel('m/s^2');
end