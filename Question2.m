clear;
close all;
clc;

%Load the data needed
load('openloop_data_1.mat');
load('constants.mat');

%Define initial condition
Ta = y(1,1);

%Time of simulation and sample time
simulation_time = t(end);
sample_time = t(2);

%The profile used at the entry of the Simulink model
u_modified = u(1,:); %Select only the data from the heater we want
profile_matrix = [t', u_modified'];

%==========================================================================
%                      Gráfico de comparação T e Ts
%==========================================================================
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.T_simulated);
hold on
plot(out.tout, out.Ts_simulated);
hold on
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T$ and $T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend('$T$', '$T_{s}$', "Interpreter", "latex", "FontSize", 12, ...
    'Location', 'southeast');
title('\textbf{Differences between the two states $T$ and $T_{s}$}', ...
    "Interpreter", "latex", "fontsize", 12);

%==========================================================================
%         Gráfico da influência dos termos de radiação e condução
%==========================================================================
figure;
plot(out.tout, out.Ts_simulated);
U = 0; %Termo de condução é zero
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
hold on
plot(out.tout, out.Ts_simulated);
hold on
U = 4.4; %Repor o termo de condução
epsilon = 0; %Termo de radiação é zero
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend( 'Unaltered Parameters',...
    '$UA(T_{a}-T)= 0$', ...
    '$\epsilon \sigma A(T_{a}^{4} - T^{4}) = 0$', ...
    "Interpreter", "latex", "FontSize", 12, 'Location', 'southeast');
title('\textbf{Importance of the conduction terms vs the radiation terms}', ...
    "Interpreter", "latex", "fontsize", 12);

%==========================================================================
%                       Gráfico da influência do U
%==========================================================================
figure;
U = 2.4; %U pequeno
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
hold on
U = 7.4; %U grande
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend('$U\downarrow$', ...
     '$U\uparrow$', "Interpreter", "latex", ...
    "FontSize", 12, 'Location', 'southeast');
title('\textbf{Effect on the system of changing the parameter $U$}', ...
    "Interpreter", "latex", "fontsize", 12);

%==========================================================================
%                     Gráfico da influência do alpha
%==========================================================================
figure;
alpha = 0.0100; %alpha pequeno
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
hold on
alpha = 0.0231; %alpha grande
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend( '$\alpha\downarrow$', ...
     '$\alpha\uparrow$', "Interpreter", ...
    "latex", "FontSize", 12, 'Location', 'southeast');
title('\textbf{Effect on the system of changing the parameter $\alpha$}', ...
    "Interpreter", "latex", "fontsize", 12);

%==========================================================================
%                     Gráfico da influência do tau
%==========================================================================
figure;
tau = 1*10^-9; %tau pequeno
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
hold on
tau = 21.1; %tau default
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
hold on;
tau = 40; %tau Grande
out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');
plot(out.tout, out.Ts_simulated);
%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T$ and $T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend('$\tau = 0$s', '$\tau = 21$s', ...
     '$\tau = 40$s', "Interpreter", ...
    "latex", "FontSize", 12, 'Location', 'southeast');
title('\textbf{Effect on the system of changing the parameter $\tau$}', ...
    "Interpreter", "latex", "fontsize", 12);
