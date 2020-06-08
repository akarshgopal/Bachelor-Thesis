function [] = plotcomparisons(time,xbaselineHistory,xHistory,yreftot,ubaselineHistory,uHistory)
%%
% Plots xyz tracking, rpy tracking, motor and tilt inputs over duration
% comparisons 
% time: 1:Ts:Duration vector.
% xbaselineHistory: baseline state history
% xHistory: lbmpc state history
% yreftot: reference history
% ubaselineHistory: baseline control history
% uHistory: lbmpc control history
%%
figure('Name','States')

%subplot(2,2,1)
hold on

plot(time,xbaselineHistory(:,1),'r--')
plot(time,xHistory(:,1),'r-')
plot(time,yreftot(:,1),'-.k')
plot(time,xbaselineHistory(:,2),'g--')
plot(time,xHistory(:,2),'g-')
plot(time,yreftot(:,2),'-.k')
plot(time,xbaselineHistory(:,3),'b--')
plot(time,xHistory(:,3),'b-')
plot(time,yreftot(:,3),'-.k')
grid on
xlabel('time (s)')
ylabel('distance (m)')
legend('x_{b}','x_{nn}','x_{ref}','y_{b}','y_{nn}','y_{ref}','z_{b}','z_{nn}','z_{ref}','Location','eastoutside')
title('Tiltrotor xyz position ')

%subplot(2,2,2)
figure('Name','States')
hold on
plot(time,xbaselineHistory(:,4),'r--')
plot(time,xHistory(:,4),'r-')
plot(time,yreftot(:,4),'-.k')
plot(time,xbaselineHistory(:,5),'g--')
plot(time,xHistory(:,5),'g-')
plot(time,yreftot(:,5),'-.k')
plot(time,xbaselineHistory(:,6),'b--')
plot(time,xHistory(:,6),'b-')
plot(time,yreftot(:,6),'-.k')
grid on
xlabel('time(s)')
ylabel('rotation(rad)')
legend('phi_{b}','phi_{nn}','phi_{ref}','theta_{b}','theta_{nn}','theta_{ref}','psi_{b}','psi_{nn}','psi_{ref}','Location','eastoutside')
title('Tiltrotor rpy orientation')

%hold off;
% Plot the manipulated variables.
%figure('Name','Control Inputs')

%subplot(2,2,3)
figure('Name','States')
hold on
stairs(time,ubaselineHistory(:,1),'--k')
stairs(time,uHistory(:,1),'b')
stairs(time,ubaselineHistory(:,2),'--k')
stairs(time,uHistory(:,2),'b')
stairs(time,ubaselineHistory(:,3),'--k')
stairs(time,uHistory(:,3),'b')
stairs(time,ubaselineHistory(:,4),'--k')
stairs(time,uHistory(:,4),'b')
ylim([-0.5,1000])
grid on
xlabel('time (s)')
ylabel('propeller speed (rad/s)')
legend('w_b','w','Location','eastoutside')
title('Prop angular speed')

%subplot(2,2,4)
figure('Name','States')
hold on

stairs(time,ubaselineHistory(:,5),'--k')
stairs(time,uHistory(:,5),'b')
stairs(time,ubaselineHistory(:,6),'--k')
stairs(time,uHistory(:,6),'b')
stairs(time,ubaselineHistory(:,7),'--k')
stairs(time,uHistory(:,7),'b')
stairs(time,ubaselineHistory(:,8),'--k')
stairs(time,uHistory(:,8),'b')
ylim([-pi-0.5,pi+0.5])
grid on
xlabel('time (s)')
ylabel('tilt angle (rad)')
title('Tilt angles')
legend('a_b','a','Location','eastoutside')
hold off;
