function maxTotalArea = objectiveFun(X)
% OBJECTIVEFUN Calculates the objective function (max total area) for fmincon.
% X = [ra, rb, La, Lb]
    
    % Extract parameters from the optimization vector X
    ra = X(1);
    rb = X(2);
    La = X(3);
    Lb = X(4);
    
    % Call the simulation function (which returns max total area as the first output)
    [maxTotalArea, ~, ~] = solvePond(ra, rb, La, Lb);
    
end
