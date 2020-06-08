function [ xdesired ] = SinxTrajectory( t )

x = 6*sin(0.5*t);
y = zeros(1,length(t));
z = zeros(1,length(t));
phi = zeros(1,length(t));
theta = zeros(1,length(t));
psi = zeros(1,length(t));
xdot = zeros(1,length(t));
ydot = zeros(1,length(t));
zdot = zeros(1,length(t));
p = zeros(1,length(t));
q = zeros(1,length(t));
r = zeros(1,length(t));

xdesired = [x;y;z;phi;theta;psi;xdot;ydot;zdot;p;q;r];
end

