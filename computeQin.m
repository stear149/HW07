%==========================================================================
% function [Q] = computeQin(t)
%
% Input Argument:
% t is the time since the beginning of the rainfall event. t is a scalar. 
% t has units of [s]
%
% Returns:
% Q is the inflow discharge to the pond at time t. Q is a scalar. 
% Q has units of [m3/s]
%
% Author: Group I
%
% Version 27 Oct. 2025
%==========================================================================
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
