clear;
close all;
clc;

%Load the data needed
load('openloop_data_1.mat');
load('constants.mat');

%Time of simulation and sample time
simulation_time = t(end);
sample_time = t(2);

%The profile used at the entry of the Simulink model
u_modified = u(1,:); %Select only the data from the heater we want
profile_matrix = [t', u_modified'];

%Run the Simulink model
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');

plot(t,y(1,:)); %Plot real temperature graph
hold on;
plot(out.tout, out.Ts_simulated); %Plot simulated temperature graph
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('Temperature [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend('Real', 'Simulated',"Interpreter", "latex", "FontSize", 12, ...
    'Location', 'southeast');
title('\textbf{Overlapping results of the real experiment and simulation}', ...
    "Interpreter", "latex", "fontsize", 12);
