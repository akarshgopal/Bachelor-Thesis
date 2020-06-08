function [] = plothistories(time,xHistory,yreftot,uHistory)
%%
% Plots xyz tracking, rpy tracking, motor and tilt inputs over duration 
% time: 1:Ts:Duration vector. 
% xHistory: state history
% yreftot: reference history
% uHistory: control history
%%
figure('Name','States')

subplot(2,2,1)
hold on
plot(time,xHistory(:,1),'r-')
plot(time,yreftot(:,1),'--m')
plot(time,xHistory(:,2),'g-')
plot(time,yreftot(:,2),'--y')
plot(time,xHistory(:,3),'b-')
plot(time,yreftot(:,3),'--c')
grid on
xlabel('time (s)')
ylabel('distance (m)')
legend('actual x','reference x','actual y','reference y','actual z','reference z','Location','southeast')
title('Tiltrotor xyz position ')

subplot(2,2,2)
hold on
plot(time,xHistory(:,4),'r-')
plot(time,yreftot(:,4),'--m')
plot(time,xHistory(:,5),'g-')
plot(time,yreftot(:,5),'--y')
plot(time,xHistory(:,6),'b-')
plot(time,yreftot(:,6),'--c')
grid on
xlabel('time(s)')
ylabel('rotation(rad)')
legend('actual phi','reference phi','actual theta','reference theta','actual psi','reference psi','Location','southeast')
title('Tiltrotor rpy orientation')

subplot(2,2,3)
hold on
stairs(time,uHistory(:,1))
stairs(time,uHistory(:,2))
stairs(time,uHistory(:,3))
stairs(time,uHistory(:,4))
ylim([-0.5,1000])
grid on
xlabel('time')
ylabel('propeller speed (rad/s)')
legend('prop1','prop2','prop3','prop4')
title('Prop speed sq')

subplot(2,2,4)
hold on

stairs(time,uHistory(:,5))
stairs(time,uHistory(:,6))
stairs(time,uHistory(:,7))
stairs(time,uHistory(:,8))
ylim([-pi-0.5,pi+0.5])
grid on
xlabel('time')
ylabel('tilt angle (rad)')
title('Tilt angles')
legend('tilt1','tilt2','tilt3','tilt4')
hold off;
grid off;
