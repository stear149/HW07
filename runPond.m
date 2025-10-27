%------------------------------------------------------------------------------
% [maxTotalArea, maxOutflow, maxDepth] = runPond(ra, rb, La, Lb)
%
% Arguments:
%   ra           Depth of head water.
%   rb
%
%   La              Number of cells infront of the dam.
%   Lb              Number of cells under of the dam.
%
%
% Returns
%   maxTotalArea        Maximum of total area of pond A and B
%   maxOutflow          Maximum of out folow from pond B
%   maxDepth            Maximum depth of ponds A and B
%
%
% Author:
%   Evan M. Stearns 
%   Owen Haberstroh
%   Lily Wilkerson
%   (Group I)
%   University of Minnesota
%
% Version:
%   26 October 2025
%
% Current best:
%   ra = 107
%   rb = 84
%
%   La = 1.102
%   Lb = 0.441
% 
%------------------------------------------------------------------------------

function [maxTotalArea, maxOutflow, maxDepth] = runPond(ra, rb, La, Lb)
    plot_output = false;
    dMax = 2.7; % [m]
    dMin = 1; % [m]
    QMaxAllowable = 1.8; % [m^3/s]
    %AMax =

    % Initial volume V0 is the volume at minimum depth D=1m for each pond.
    Vo = [computeVolume(dMin, ra); computeVolume(dMin, rb)];

    % Use Tspan from the problem statement: 0 to 24 hours (86400 s)
    Tspan = linspace(0, 24*60*60, 10001); 
    
    % Solve the ODE system
    [T,V] = ode45(@(t,V) computeVdot(t, V, ra, rb, La, Lb), Tspan, Vo);
    
    % --- Post-Processing: Time-Series Calculations ---
    
    % Pond 1 (alpha)
    Qina = arrayfun(@(t) computeQin(t), T);
    Va = V(:,1);
    Da = arrayfun(@(v) computeDepth(v, ra), Va);
    Qouta = arrayfun(@(d) computeQout(d, La), Da);
    AreaA = pi * (ra + 4 * Da).^2; 
    
    % Pond 2 (beta)
    Vb = V(:,2);
    Db = arrayfun(@(v) computeDepth(v, rb), Vb);
    Qoutb = arrayfun(@(d) computeQout(d, Lb), Db);    
    AreaB = pi * (rb + 4 * Db).^2; 
    
    % --- 1. Calculate Required Output Variables ---

    % Maximum depths (a 2x1 matrix)
    maxDepth = [max(Da); max(Db)]; 
    
    % Maximum outflow from the second pond (Q_out_beta)
    maxOutflow = max(Qoutb); 
    
    % Maximum total combined surface area (TotalArea = A_a + A_b)
    maxTotalArea = max(AreaA) + max(AreaB);

    
    % --- 2. Generate Graphical Output ---
    if plot_output
        figure; % Open a new figure window

        % Plot 1 (Location 1: Upper-Left) Flow vs. Time
        subplot(2, 2, 1);
        plot(T, Qina, 'b-', 'LineWidth', 2); hold on;
        plot(T, Qouta, 'g--', 'LineWidth', 2);
        plot(T, Qoutb, 'r-.', 'LineWidth', 2); hold off;
        title('Flow vs. Time');
        xlabel('time [s]');
        ylabel('Flow [m^3/s]');
        legend('inflow', 'through flow', 'outflow', 'Location', 'northeast');
        grid on;

        % Plot 2 (Location 2: Upper-Right) Depth vs. Time
        subplot(2, 2, 2);
        plot(T, Da, 'b-', 'LineWidth', 2); hold on;
        plot(T, Db, 'r--', 'LineWidth', 2); hold off;
        title('Depth vs. Time');
        xlabel('time [s]');
        ylabel('Depth [m]');
        legend('Pond \alpha Depth', 'Pond \beta Depth', 'Location', 'northeast');
        % Add a line at D=1m (minimum depth) for reference
        yline(1.0, 'k:'); hold on;
        hold off;
        grid on;

        % Plot 3 (Location 3: Lower-Left) Surface Area vs. Time
        subplot(2, 2, 3);
        plot(T, AreaA, 'b-', 'LineWidth', 2); hold on;
        plot(T, AreaB, 'r--', 'LineWidth', 2); hold off;
        title('Surface Area vs. Time');
        xlabel('time [s]');
        ylabel('Area [m^2]');
        legend('Pond \alpha Area', 'Pond \beta Area', 'Location', 'northeast');
        grid on;

        % Plot 4 (Location 4: Lower-Right) Volume vs. Time
        subplot(2, 2, 4);
        plot(T, V(:, 1), 'b-', 'LineWidth', 2); hold on;
        plot(T, V(:, 2), 'r--', 'LineWidth', 2); hold off;
        title('Volume vs. Time');
        xlabel('time [s]');
        ylabel('Volume [m^3]');
        legend('Pond \alpha Volume', 'Pond \beta Volume', 'Location', 'northeast');
        grid on;

    end

    % Check for valid design
    try
        validityCheck(maxOutflow, QMaxAllowable, maxDepth, dMax);
    catch
        % If no function is found, do nothing
    end
    
    fprintf('\nMax Total Area (m^2): %.3f\n', maxTotalArea);
    fprintf('Max Depth (m):   [%.3f, %.3f]\n', maxDepth(1), maxDepth(2));
    fprintf('Max Outflow (m^3/s): %.3f\n\n', maxOutflow);

end

