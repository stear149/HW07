%==========================================================================
% function[maxTotalArea, maxOutflow, maxDepth] = runPond(ra, rb, La, Lb)
%
% Input Arguments:
% ra is the base radius of the first pond. ra is a scalar. 
% ra has units [m]
%
% rb is the base radius of the second pond. rb is a scalar. 
% rb has units [m]
%
% La is the length of the weir in the first pond. La is a scalar. 
% La has units of [m]
%
% Lb is the length of the weir in the second pond. Lb is a scalar. 
% Lb has units of [m]
%
% Returns:
% maxTotalArea, the maximum total surface area of the two ponds combined
% maxTotalArea has units of [m2]
%
% maxOutflow, the maximum outflow from the second pond
% maxOutflow has units of [m^3/s]
%
% maxDepth, the maximum depths of the two ponds
% maxDepth(1) is the maximum depth of the first pond 
% maxDepth(2) is the maximum depth of the second pond
% maxDepth has units of [m]
%
% Author:
% Group I
%
% Version 23 Oct. 2025
%==========================================================================

function[maxTotalArea, maxOutflow, maxDepth] = runPond(ra, rb, La, Lb)
    dmax = 2.7;
    dmin = 1;

    Vo = [computeVolume(1, ra); computeVolume(1, rb)];
    Tspan = linspace(0, 24*60*60, 10001);

    [T,V] = ode45(@(t,V) computeVdot(t, V, ra, rb, La, Lb), Tspan, Vo);

    %maxDepth(1,1) =
    %maxDepth(2,1) =

    %pond 1
    Qai = arrayfun(@(t) computeQin(t), T);
    Va = V(1,1);
    da = arrayfun(@(v) computeDepth(v, ra), Va);
    Qao = arrayfun(@(d) computeQout(d, La), da);

    %pond 2
    Vb = V(2,1);
    db = arrayfun(@(v) computeDepth(v, rb), Vb);
    Qbo = arrayfun(@(d) computeQout(d, Lb), db);

    %plot 1, flows
    plot(T, Qai)
    hold on;
    plot(da, Qao)
    plot(db, Qbo)
    hold off;

    %plot 2, depths


    %plot 3, surface area
    %surfacea =
    %surfaceb =

    %plot(T, surfacea)
    %hold on;
    %plot(T, surfaceb)
    %hold off;

    %plot 4, volume



end
