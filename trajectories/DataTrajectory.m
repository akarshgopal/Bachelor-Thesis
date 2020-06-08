function [ xdesired ] = DataTrajectory( t )
% This function generates reference signal for nonlinear MPC controller
% used in the quadrotor path following example.

% Copyright 2019 The MathWorks, Inc.

%#codegen
%{
x = sin(t/10) + sin(t/8) + sin(t/5);
y = sin(t/15) + sin(t/6) + sin(t/3);
z = sin(t/12) + sin(t/9) + sin(t/6);
phi = zeros(1,length(t)); %2*pi*sin(t/10);
theta = zeros(1,length(t));
psi = 2*pi*sin(t/10);
xdot = zeros(1,length(t));
ydot = zeros(1,length(t));
zdot = zeros(1,length(t));
phidot = zeros(1,length(t));
thetadot = zeros(1,length(t));
psidot = zeros(1,length(t));

xdesired = [x;y;z;phi;theta;psi;xdot;ydot;zdot;phidot;thetadot;psidot];
%}
x = sin(t/10) + sin(t/8) + sin(t/5);
y = sin(t/15) + sin(t/6) + sin(t/3);
z = sin(t/12) + sin(t/9) + sin(t/6);
phi = zeros(1,length(t)); %2*pi*sin(t/10);
theta = zeros(1,length(t));
psi = zeros(1,length(t));
xdot = zeros(1,length(t));
ydot = zeros(1,length(t));
zdot = zeros(1,length(t));
phidot = zeros(1,length(t));
thetadot = zeros(1,length(t));
psidot = zeros(1,length(t));

xdesired = [x;y;z;phi;theta;psi;xdot;ydot;zdot;phidot;thetadot;psidot];

end

