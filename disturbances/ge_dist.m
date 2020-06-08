function [F_dist] = ge_dist(xk,uk)
        f_t = 8e-5*sum(uk(1:4).^2);
        g_e = 1/(1-3*(0.45/(7+xk(3)))^2);
        F_dist = [0 0 f_t*(g_e-1)];
end
