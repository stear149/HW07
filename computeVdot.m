%==========================================================================
% function[dv] = computeVdot(t, V, ra, rb, La, Lb)
%
% Input Arguments:
% t is the time since the beginning of the rainfall event. t is a scalar. 
% t has units of [s]
%
% V is the volume of water in the ponds. V is a (2 × 1) matrix: 
% V(1) is the volume in the first pond 
% V(2) is the volume in the second pond. V has units of [m3]
%
% ra is the base radius of the first pond. ra is a scalar. 
% ra has units of [m]
%
% rb is the base radius of the second pond. rb is a scalar. 
% rb has units of [m]
%
% La is the length of the weir in the first pond. La is a scalar. 
% La has units of [m]
%
% Lb is the length of the weir in the second pond. Lb is a scalar. 
% Lb has units of [m]
%
% Returns:
% dVdt is the first derivatives of the pond volumes with respect to time 
% dVdt is a (2 × 1) matrix: 
% dVdt(1) is the derivative for the first pond
% dVdt(2) is the derivative for the second pond. dVdt has units of [m^3/s]
%
% Author: Group I
%
% Version 27 Oct. 2025
%==========================================================================
function [dv] = computeVdot(t, V, ra, rb, La, Lb)
    
    % --- Pond Alpha (Pond 1) ---
    Va = V(1); 
    Da = computeDepth(Va, ra);
    Qina = computeQin(t);
    Qouta = computeQout(Da, La);

    % Derivative for Pond Alpha
    dVadt = Qina - Qouta;
    
    % --- Pond Beta (Pond 2) ---
    Vb = V(2);
    Db = computeDepth(Vb, rb);

    % Inflow to Pond Beta is the Outflow from Pond Alpha
    Qinb = Qouta;

    % Outflow from Pond Beta
    Qoutb = computeQout(Db, Lb);

    % Derivative for Pond Beta
    dVbdt = Qinb - Qoutb;
    
    % dV/dt
    dv = [dVadt; dVbdt];
end
