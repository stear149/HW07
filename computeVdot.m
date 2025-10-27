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
