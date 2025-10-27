function [C, Ceq] = nonlinCon(X, D_max, Q_max)
% NONLINCON Defines the nonlinear inequality constraints for fmincon.
% The constraints must be in the form C(X) <= 0.
% Ceq (equality constraints) is left empty.
% X = [ra, rb, La, Lb]
    
    % Ensure Ceq is empty (no equality constraints)
    Ceq = [];
    
    % Extract parameters from the optimization vector X
    ra = X(1);
    rb = X(2);
    La = X(3);
    Lb = X(4);
    
    % Call the simulation function to get the required metrics
    [~, maxOutflow, maxDepth] = solvePond(ra, rb, La, Lb);
    
    % --- Define Inequality Constraints C(X) <= 0 ---
    
    % 1. Max Depth Constraint (Pond alpha and Pond beta): D_max_pond - D_allowable <= 0
    
    % C(1): Pond alpha max depth must be <= D_max
    C(1) = maxDepth(1) - D_max; 
    
    % C(2): Pond beta max depth must be <= D_max
    C(2) = maxDepth(2) - D_max; 
    
    % 2. Max Outflow Constraint (Pond beta outflow): Q_max_outflow - Q_allowable <= 0
    
    % C(3): Max outflow must be <= Q_max
    C(3) = maxOutflow - Q_max; 
end
