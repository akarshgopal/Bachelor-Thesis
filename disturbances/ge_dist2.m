function [F_dist] = ge_dist2(xk,uk)
        f_t = 8e-5*sum(uk(1:4).^2);
        R = 0.45;
        z = 7+xk(3);
        d=0.55;
        K=2;
        g_e = 1/( 1-(R/(4*z))^2 - R^2*(z/sqrt((d^2+4*z*2)^3)) - R^2/2*(z/sqrt((2*d^2+4*z*2)^3))-2*R^2*K*(z/sqrt((d^2+4*z*2)^3)));
        F_dist = [0 0 f_t*(g_e-1)];
end