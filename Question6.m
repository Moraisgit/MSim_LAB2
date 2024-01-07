clear
close all
clc

% Load experimental data obtained with the profile from Question 1 
load('openloop_data_1.mat');
u = u(1,:);
y = y(1,:);

% Nominal parameters
U = 4.6;     % W/m^2-K
alpha = 0.0131;  % W/%
tau = 21.1;    % s

p0 = [U, alpha, tau]; % initial guess

% Initial conditions
x0 = y(1);

% Optimize parameters
[p_opt,J_opt,~,exitflag,output] = lsqcurvefit(@(p,~)tclabsim(t,x0,u,p),p0,[],y,[0 0 0]);
U_opt = p_opt(1);
alpha_opt = p_opt(2);
tau_opt = p_opt(3);

% Load experimental data obtained with the new profile
load('openloop_data_2.mat');
y = y(1,:);
x0 = y(1,1);

% Get simulated data with optimal parameters and new profile
y_sim_opt = tclabsim(t,x0,u,p_opt);

% Calculate square error between real and simulated data
J = least_square_error(y, y_sim_opt);
fprintf("Cost: %f\n", J);

% Plot graph
plot(t,y); %Plot real temperature graph
hold on;
plot(t,y_sim_opt); %Plot simulated temperature graph

%Add elements to the graph
grid on;
xlabel('Time [s]', "Interpreter", "latex", "fontsize", 12);
ylabel('$T_{s}$ [$^{\circ}$C]', ...
    "Interpreter", "latex", "fontsize", 12);
legend('Real', 'Simulated',"Interpreter", "latex", "FontSize", 12, ...
    'Location', 'southeast');
title('\textbf{Overlapping results of the real experiment and simulation}', ...
    "Interpreter", "latex", "fontsize", 12);

%==========================================================================
%                      Function to calculate the cost
%==========================================================================
function y = least_square_error (y_real, y_sim)
    % The cost
    J = 0;

    for ii = 1:length(y_sim)
        J = J + (y_sim(ii) - y_real(ii))^2;
    end

    y = J;
end