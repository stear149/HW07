% OPTIMIZEPONDDESIGN
%
% This script uses fmincon to find the optimal design parameters (ra, rb, La, Lb)
% that minimize the maximum total surface area, subject to constraints on 
% maximum depth and maximum outflow.
%
% Design Variables (X):
% X(1) = ra (Base radius of Pond alpha)
% X(2) = rb (Base radius of Pond beta)
% X(3) = La (Weir length of Pond alpha)
% X(4) = Lb (Weir length of Pond beta)
% To run type "optimizePondDesign" in to the CMD

% --- 1. Define Problem Parameters and Initial Guess ---

% Initial Guess (X0) - Start with some reasonable values
% These values will significantly affect convergence.
ra0 = 100;    % Initial guess for ra [m]
rb0 = 95;    % Initial guess for rb [m]
La0 = 1.5;    % Initial guess for La [m]
Lb0 = .5;    % Initial guess for Lb [m]
X0 = [ra0, rb0, La0, Lb0];

% Lower Bounds (LB) - All dimensions must be positive
LB = [0.1, 0.1, 0.1, 0.1]; % Use a small positive number instead of zero

% Upper Bounds (UB) - Use a very large number for an initial wide search space
UB = [100, 100, 20, 20]; % Radii up to 100m, Lengths up to 20m

% Constraints (Hard Limits from the Problem Statement):
D_max = 2.7;  % [m] - Maximum allowable depth in either pond
Q_max = 1.8;  % [m^3/s] - Maximum allowable outflow from Pond beta

% --- 2. Setup Optimization Options and Solver ---

% Set up fmincon options
options = optimoptions('fmincon', ...
                       'Algorithm', 'sqp', ... % Sequential Quadratic Programming (good for non-linear)
                       'Display', 'iter', ...  % Show iteration details
                       'MaxFunctionEvaluations', 5000, ...
                       'TolFun', 1e-4, ...     % Tolerance on the function value
                       'TolX', 1e-3);         % Tolerance on the design variables X (0.001)

% Define the objective function (Area minimization)
obj_fun = @(X) objectiveFun(X);

% Define the nonlinear constraint function (Depth and Outflow)
nonlin_con = @(X) nonlinCon(X, D_max, Q_max);

% Note: Aeq, beq, A, b are left empty as we only have nonlinear constraints.
A = []; b = []; Aeq = []; beq = [];

% --- 3. Run Optimization ---

fprintf('\n--- Starting fmincon Optimization ---\n');

[X_opt, fval_opt, exitflag, output] = fmincon(obj_fun, X0, A, b, Aeq, beq, LB, UB, nonlin_con, options);

% --- 4. Display Results ---

if exitflag > 0
    fprintf('\n\n--- OPTIMIZATION SUCCESSFUL ---\n');
    fprintf('Optimal Parameters:\n');
    fprintf('  Base Radius Pond alpha (ra): %.5f m\n', X_opt(1));
    fprintf('  Base Radius Pond beta (rb):  %.5f m\n', X_opt(2));
    fprintf('  Weir Length Pond alpha (La): %.5f m\n', X_opt(3));
    fprintf('  Weir Length Pond beta (Lb):  %.5f m\n\n', X_opt(4));
    
    fprintf('\nMinimized Max Total Area (m^2): %.3f\n', fval_opt);
    fprintf('Optimal Max Depth (m):   [%.3f, %.3f]\n', max_depth_opt(1), max_depth_opt(2));
    fprintf('Optimal Max Outflow (m^3/s): %.3f\n\n', max_outflow_opt);

    [maxTotalArea, max_outflow_opt, max_depth_opt] = solvePond(X_opt(1), X_opt(2), X_opt(3), X_opt(4));

    
else
    fprintf('\n\n--- OPTIMIZATION FAILED OR DID NOT CONVERGE ---\n');
    disp(output);
end
