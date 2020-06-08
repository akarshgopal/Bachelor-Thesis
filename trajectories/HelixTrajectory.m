function [ xdesired ] = HelixTrajectory( t )

x = 2*cos(0.943*t);
y = 2*sin(0.943*t);
z = 0.2*t;
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

