function xk1 = TiltrotorDiscrete_model(xk, uk, Ts)
%in1: xk (12x1) - state vector 
%in2: uk (8x1) - input vector
%in3: Ts (1x1) - sampling time
%out: xk1 (12x1) - Discrete state update 

% M=1 -> 0.1 s Forward Euler integration. Empirically seems to be accurate
% enough.
M=1;
xk1=xk;
for i=1:M
xk1 = xk1+Ts/M*TiltrotorModel_Eul(xk1,uk);
end
