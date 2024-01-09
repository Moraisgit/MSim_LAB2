clear
close all
clc

% Load experimental data
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

if exitflag > 0
    fprintf('\nFitted parameters:\n')
    fprintf('\tU = %.3f W/m^2-K\n',U_opt)
    fprintf('\talpha = %.5f W/%%\n',alpha_opt)
    fprintf('\ttau = %.3f s\n',tau_opt)
    fprintf('Optimal cost: J* = %.3f\n',J_opt)
else
    warning('Minimization unsuccessful.')
end

% Define a grid of values for U, alpha and tau
U_values = linspace(U_opt - 1, U_opt + 1, 50);
alpha_values = linspace(alpha_opt - 0.003, alpha_opt + 0.003, 50);
tau_values = linspace(tau_opt - 3, tau_opt + 3, 50);

% Initialize matrices to store results
J_values_tau = zeros(length(U_values), length(alpha_values));
J_values_alpha = zeros(length(U_values), length(tau_values));

% Let tau be constant
fixed_tau = tau_opt;

% Let minimum be huge
minimum_J_values_tau = 1e10;
minimum_J_values_alpha = 1e10;

% Loop over U and alpha values
for ii = 1:length(U_values)
    for jj = 1:length(alpha_values)
        % Get the simulated data
        current_y_sim = tclabsim(t,x0,u,[U_values(ii), ...
            alpha_values(jj), fixed_tau]);

        J_values_tau(ii,jj) = least_square_error(y, current_y_sim);

        if J_values_tau(ii,jj) < minimum_J_values_tau
            minimum_J_values_tau = J_values_tau(ii,jj);
        end
    end
end

% Let alpha be constant
fixed_alpha = alpha_opt;

% Loop over U and alpha values
for ii = 1:length(U_values)
    for jj = 1:length(tau_values)
        % Get the simulated data
        current_y_sim = tclabsim(t,x0,u,[U_values(ii), ...
            fixed_alpha, tau_values(jj)]);

        J_values_alpha(ii,jj) = least_square_error(y, current_y_sim);

        if J_values_alpha(ii,jj) < minimum_J_values_alpha
            minimum_J_values_alpha = J_values_alpha(ii,jj);
        end
    end
end

display(minimum_J_values_tau);
display(minimum_J_values_alpha);

% Plot the surface for tau constant
surf(alpha_values, U_values, J_values_tau);
grid on;
xlabel('$\alpha$', "Interpreter", "latex", "fontsize", 12);
ylabel('$U$',"Interpreter", "latex", "fontsize", 12);
zlabel('Cost ($J$)',"Interpreter", "latex", "fontsize", 12);
colorbar;
title('\textbf{Surface Plot of Cost Function - Fixed $\tau$}', ...
    "Interpreter", "latex", "fontsize", 12);

% Plot the surface for alpha constant
figure;
surf(tau_values, U_values, J_values_alpha);
grid on;
xlabel('$\tau$', "Interpreter", "latex", "fontsize", 12);
ylabel('$U$',"Interpreter", "latex", "fontsize", 12);
zlabel('Cost ($J$)',"Interpreter", "latex", "fontsize", 12);
colorbar;
title('\textbf{Surface Plot of Cost Function - Fixed $\alpha$}', ...
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
