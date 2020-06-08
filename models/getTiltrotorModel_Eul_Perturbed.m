% This script defines a continuous-time nonlinear quadrotor model and
% generates a state function 

% Create symbolix variables for states, MVs and parameters
syms xt(t) yt(t) zt(t) phit(t) thetat(t) psit(t)...
    xdott(t) ydott(t) zdott(t) pt(t) qt(t) rt(t)

syms u1 u2 u3 u4 a1 a2 a3 a4
syms Ixx Iyy Izz k l m b g
syms x y z phi theta psi xdot ydot zdot phidot thetadot psidot p q r

%%

% Moments of Inertia
%+-0.05
IxxVal = 1.25; % kgm 
IyyVal = 1.15; % kgm
IzzVal = 2.2; % kgm

% Estimated Mass based on CAD model: 12kg (including batteries modelled as
% steel 3kgx2) Taking ~6kg for quadrotor model and discounting the 'steel'
% batteries
%Not perturbing mass because it is unlikely to be erroneuously estimated.
mVal = 6; %kg

% CAD model reference has 55cm arms
lVal = 0.55; %m

% Propeller Thrust coeff
%17x5.8 inch prop http://store-en.tmotor.com/goods.php?id=347
%Taking 2.6kg max thrust at 5400 RPM => kval ~8e-5, taking bVal 1/20*xkVal
%=> bVal ~4e-6

%0.1
kVal = 8.1e-5; % Ns^2/rad^2

% -5%
% Propeller Drag coeff (Counter torque)
bVal = 3.9e-6; % Nms^2/rad^2

%Gravity
gVal = 9.81; %m/s/s

%%
paramValues = [IxxVal IyyVal IzzVal kVal lVal mVal bVal gVal];

% Group symbolic variables
statet = {xt(t) yt(t) zt(t) phit(t) thetat(t) psit(t) xdott(t) ...
    ydott(t) zdott(t) pt(t) qt(t) rt(t)};

state = {x y z phi theta psi xdot ydot zdot p q r};

state_diff = {diff(xt(t),t), diff(yt(t),t), diff(zt(t),t), ...
    diff(phit(t),t), diff(thetat(t),t), diff(psit(t),t)};

state_dot = {xdot ydot zdot phidot thetadot psidot};

%%

%R-ZYX Euler
Rz = [cos(psit), -sin(psit), 0;
      sin(psit), cos(psit), 0;
      0, 0, 1];
Ry = [cos(thetat), 0, sin(thetat);
      0, 1, 0;
      -sin(thetat), 0, cos(thetat)];
Rx = [1, 0, 0;
      0, cos(phit), -sin(phit);
      0, sin(phit), cos(phit)];

% Rotation matrix from body frame to inertial frame
R = Rz*Ry*Rx;

% Inertia Tensor
I = [Ixx, 0, 0; 0, Iyy, 0; 0, 0, Izz];


%%
% Torques in the direction of phi, theta, psi
tau_beta = [l*k*(u2^2*cos(a2) - u4^2*cos(a4)) - b*(u2^2*sin(a2) - u4^2*sin(a4)); 
            l*k*(u3^2*cos(a3) - u1^2*cos(a1)) + b*(u1^2*sin(a1) - u3^2*sin(a3));
            l*k*(u1^2*sin(a1) + u2^2*sin(a2) + u3^2*sin(a3) + u4^2*sin(a4)) + ...
            b*(u1^2*cos(a1) - u2^2*cos(a2) + u3^2*cos(a3) - u4^2*cos(a4))];
           

F_b =  k*(u1^2*[0;        sin(a1);  cos(a1)] + ...
       u2^2*[-sin(a2); 0;        cos(a2)] +  ...
       u3^2*[0;        -sin(a3); cos(a3)] +  ...
       u4^2*[sin(a4);  0;        cos(a4)]);

%%   
% Dynamics
f(1) = xdott;
f(2) = ydott;
f(3) = zdott;
f(4) = pt+sin(phit)*tan(thetat)*qt + cos(phit)*tan(thetat)*rt;
f(5) = cos(phit)*qt -sin(phit)*rt;
f(6) = sin(phit)*sec(thetat)*qt + cos(phit)*sec(thetat)*rt;

% Equations for COM configuration
f(7:9) = -g*[0;0;1] + R*F_b/m;

% Euler Lagrange equations for angular dynamics
f(10:12) = inv(I)*(tau_beta - cross([pt(t); qt(t); rt(t)],I*[pt(t); qt(t); rt(t)]));

% Replace parameters and drop time dependence
f = subs(f, [Ixx Iyy Izz k l m b g], paramValues);
f = subs(f,statet,state);
f = simplify(f);

control = [u1, u2, u3, u4, a1, a2, a3, a4];

% Create QuadrotorStateFcn.m
matlabFunction(transpose(f),'File','TiltrotorModel_Eul_Perturbed',...
    'Vars',{transpose([state{:}]),transpose(control)})

%Clear symbolic variables
clear
