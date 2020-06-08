function [F_dist] = sigmoid_dist(xk,uk)
        f_t = 8e-5*sum(uk(1:4).^2);
        F_dist = [0 0 1/4*f_t*(1-1/(1+exp(-xk(3))))];
end
