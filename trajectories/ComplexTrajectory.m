function [ xdesired ] = ComplexTrajectory( t )
x = sin(t/10) + sin(t/8).*sin(t/1000) + sin(t/5) + sin(t/100)+ 3*sin(t/500);
y = sin(t/15).*cos(t/1000) + sin(t/6) + sin(t/3) + sin(t/120) + 3*sin(t/500);
z = sin(t/12) + sin(t/9) + sin(t/6) + sin(t/150);
phi = zeros(1,length(t));
theta = zeros(1,length(t));
psi = pi*sin(t/20);
xdot = zeros(1,length(t));
ydot = zeros(1,length(t));
zdot = zeros(1,length(t));
phidot = zeros(1,length(t));
thetadot = zeros(1,length(t));
psidot = zeros(1,length(t));

xdesired = [x;y;z;phi;theta;psi;xdot;ydot;zdot;phidot;thetadot;psidot];

end