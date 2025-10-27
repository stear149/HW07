function [Q] = computeQin(t)
   tau = t/21600;
    if t < 0
        Q = 0;
    elseif t < 21600
        Q = (800*tau^2)*(1-tau)^5;
    else
        Q = 0;
    end
end 