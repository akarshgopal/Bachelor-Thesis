%

%Input1: state: [x y z phi theta psi xdot ydot zdot p q r]
%Input2: input: [u1 u2 u3 u4 a1 a2 a3 a4]              
%Output: statedot: [xdot ydot zdot phidot thetadot psidot xdotdot ydotdot zdotdot pdotdot qdotdot rdotdot]

% This script defines a continuous-time nonlinear 6DOF model and
% generates a state function used by the
% nonlinear MPC controller 

% Create symbolic variables for states, MVs and parameters
%time dependent vars
syms xt(t) yt(t) zt(t) xdott(t) ydott(t) zdott(t) ...
     phit(t) thetat(t) psit(t) pt(t) qt(t) rt(t) ...
    a1t(t) a2t(t) a3t(t) a4t(t) ...
    w1t(t) w2t(t) w3t(t) w4t(t) 

%input vars
syms u1 u2 u3 u4 ar1 ar2 ar3 ar4 

%hidden dynamics
syms w1 w2 w3 w4 w1dot w2dot w3dot w4dot a1 a2 a3 a4 a1dot a2dot a3dot a4dot ...
    Fd_x Fd_y Fd_z

%parameters
syms Ixx Iyy Izz k l m b g cdx cdy cdz tilt maxtiltspeed motor 

%state vars
syms x y z xdot ydot zdot phi theta psi phidot thetadot psidot p q r

%% 

% Set values for dynamics parameters
% Moments of Inertia taken with reference to CAD model, adapted to
% quadrotor
IxxVal = 1.2; % kgm^2 
IyyVal = 1.2; % kgm^2
IzzVal = 2.3; % kgm^2

% Propeller Thrust coeff
%17x5.8 inch prop http://store-en.tmotor.com/goods.php?id=347
%Taking 2.6kg max thrust at 5400 RPM => kval ~8e-5, taking bVal 1/20*xkVal
%=> bVal ~4e-6
kVal = 8e-5; % Ns^2/rad^2

% Propeller Drag coeff (Counter torque)
bVal = 4e-6; % Nms^2/rad^2

% CAD model reference has 55cm arms
lVal = 0.55; %m

% Estimated Mass based on CAD model: 12kg (including batteries modelled as
% steel 3kgx2) Taking ~6kg for quadrotor model and discounting the 'steel'
% batteries
mVal = 6; %kg

%Gravity
gVal = 9.81; %m/s/s

% cd = 0.5*rho*Aref*Cd. Exaggerating drag coefficient. Realistically 10x
% lower ~0.01
cdxVal = 0.01; %Ns^2/m^2
cdyVal = 0.01; %Ns^2/m^2
cdzVal = 0.05; %Ns^2/m^2

%Tilt servo time constant
tiltVal = 0.2; % 200 ms to get 67% of tilt. Value based on 0.2s for 60deg at 1kg1cm
maxtiltspeedVal = pi; %max tilt speed capped at 180deg/s 
motorVal = 0.01; % 10 ms to get 67% of motor speedup (mechanical time constant

%%
paramValues = [IxxVal IyyVal IzzVal kVal lVal mVal bVal gVal ...
    cdxVal cdyVal cdzVal tiltVal maxtiltspeedVal motorVal];

% Group symbolic variables
statet = {xt(t) yt(t) zt(t) phit(t) thetat(t) psit(t) ...
          xdott(t) ydott(t) zdott(t) pt(t) qt(t) rt(t) ...
          a1t(t) a2t(t) a3t(t) a4t(t) ...
          w1t(t) w2t(t) w3t(t) w4t(t)  };

state = {x y z phi theta psi xdot ydot zdot p q r ...
    a1 a2 a3 a4 w1 w2 w3 w4 };

state_diff = {diff(xt(t),t), diff(yt(t),t), diff(zt(t),t), ...
    diff(phit(t),t), diff(thetat(t),t), diff(psit(t),t), ...
    diff(a1t(t),t), diff(a2t(t),t), diff(a3t(t),t), diff(a4t(t),t), ...
    diff(w1t(t),t), diff(w2t(t),t), diff(w3t(t),t), diff(w4t(t),t)
    };

state_dot = {xdot ydot zdot phidot thetadot psidot a1dot a2dot a3dot a4dot w1dot w2dot w3dot w4dot};


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

%%
% Inertia tensor
I = [Ixx, 0, 0; 0, Iyy, 0; 0, 0, Izz];

%%
% Torques in the direction of x, y, z in body axis
tau_beta = [l*k*(w2t^2*cos(a2t) - w4t^2*cos(a4t)) - b*(w2t^2*sin(a2t) - w4t^2*sin(a4t)); 
            l*k*(w3t^2*cos(a3t) - w1t^2*cos(a1t)) + b*(w1t^2*sin(a1t) - w3t^2*sin(a3t));
            l*k*(w1t^2*sin(a1t) + w2t^2*sin(a2t) + w3t^2*sin(a3t) + w4t^2*sin(a4t)) + ...
            b*(w1t^2*cos(a1t) - w2t^2*cos(a2t) + w3t^2*cos(a3t) - w4t^2*cos(a4t))];
           
% Total thrust
F_b =  k*(w1t^2*[0;        sin(a1t);  cos(a1t)] + ...
       w2t^2*[-sin(a2t); 0;        cos(a2t)] +  ...
       w3t^2*[0;        -sin(a3t); cos(a3t)] +  ...
       w4t^2*[sin(a4t);  0;        cos(a4t)]);
%% 
% Drag Force
F_d = [cdx cdy cdz]*(R'*[xdott; ydott; zdott]).^2;

% External Disturbance
disturbance = [Fd_x; Fd_y; Fd_z];

% Dynamics
f(1) = xdott;
f(2) = ydott;
f(3) = zdott;

f(4) = pt+sin(phit)*tan(thetat)*qt + cos(phit)*tan(thetat)*rt;
f(5) = cos(phit)*qt -sin(phit)*rt;
f(6) = sin(phit)*sec(thetat)*qt + cos(phit)*sec(thetat)*rt;

% Equations for COM configuration
f(7:9) = R*(F_b-F_d)/m -[0;0;g] + disturbance/m;

% Euler Lagrange equations for angular dynamics
f(10:12) = inv(I)*(tau_beta - cross([pt(t); qt(t); rt(t)],I*[pt(t); qt(t); rt(t)]));

%tilting dynamics
%first order system
f(13) = (ar1 - a1t)/tilt;
f(14) = (ar2 - a2t)/tilt;
f(15) = (ar3 - a3t)/tilt;
f(16) = (ar4 - a4t)/tilt;

%motor dynamics
%first order system
f(17) = (u1-w1t)/motor;
f(18) = (u2-w2t)/motor;
f(19) = (u3-w3t)/motor;
f(20) = (u4-w4t)/motor;

% Replace parameters and drop time dependence
f = subs(f, [Ixx Iyy Izz k l m b g cdx cdy cdz tilt maxtiltspeed motor], paramValues);
f = subs(f,statet,state);
f = simplify(f);

control = [u1, u2, u3, u4, ar1, ar2, ar3, ar4];

% Create QuadrotorStateFcn.m
matlabFunction(transpose(f),'File','TiltrotorPlant_fd_Eul',...
    'Vars',{transpose([state{:}]),transpose(control),transpose(disturbance)})

%Clear symbolic variables
clear
