% Open-loop experiment for data collection in TCLab
%
% Initializes TCLab, applies a sequence of open-loop controls and records
% the corresponding temperature.
%
% If you see the warning 'Computation time exceeded sampling time by x
% seconds at sample k', it is because the computation time in a given
% loop took more than the sampling period Ts. Try to disable the rt_plot
% flag to fix it or increase Ts.
%
% Functions called: tclab.
%
% J. Miranda Lemos and Afonso Botelho, IST, May 2023
%__________________________________________________________________________

% Initialization
clear all
close all
clc
tclab;

% Experiment parameters
T = 1600; % experiment duration [s]
Ts = 2; % sampling period [s]
N = T/Ts; % number of samples to collect

% Open-loop profile
u = zeros(2,N);

left_bound = 1; %Number of the sample that starts the interval
right_bound = 1; %Number of the sample that ends the interval

while right_bound < N %Loop until we reach N samples
    % Generate a random duration for the interval between 15 and 75 samples
    nr_samples = randi([15,75]);
    % Generate a random percentage of heat for the interval between 0 and 80
    heat_percentage = randi(100);
    
    % Check if the right_bound exceeds N
    if right_bound + nr_samples > N
        nr_samples = N - right_bound; % Adjust the interval length
    end
    
    % Update right_bound
    right_bound = right_bound + nr_samples;
    
    % Add the random interval with the random percentage to the array u
    u(1, left_bound:right_bound) = heat_percentage;
    
    % Update left bound to move to the next interval
    left_bound = right_bound;
end

% Real-time plot flag. If true, plots the input and measured temperature in
% real time. If false, only plots at the end of the experiment and instead
% prints the results in the command window.
rt_plot = true;

% Initialize figure and signals
if rt_plot
    figure
    drawnow;
end
t = nan(1,N);
y = nan(2,N);

% String with date for saving results
timestr = char(datetime('now','Format','yyMMdd_HHmmSS'));

% Signals the start of the experiment by lighting the LED
led(1)
disp('Temperature test started.')
cooling = 0;
for k=1:N
    tic;

    % Computes analog time
    t(k) = (k-1)*Ts;
    
    % Reads the sensor temperatures
    y(1,k) = T1C();
    y(2,k) = T2C();
    
%     % If the temperature exceeds 58 degrees a 0% heat percentage is
%     % applied until it reaches 55 degrees
%     if y(1,k)>55 || y(2,k)>55
%         if y(1,k)>58 || y(2,k)>58
%             if cooling == 0
%                 cooling = 1;
%             end
%             % Applies a heat percentage of 0 to cool
%             u(1,k) = 0;
%             u(2,k) = 0;
%         else
%             if cooling == 1
%                 % Applies a heat percentage of 0 to cool
%                 u(1,k) = 0;
%                 u(2,k) = 0;
%             end
%         end
%     else
%         if cooling == 1
%             cooling = 0;
%         end
%     end

    % Applies the control variables to the plant
    h1(u(1,k));
    h2(u(2,k));
    
    if rt_plot
        % Plots results
        clf
        subplot(2,1,1), hold on, grid on   
        plot(t(1:k),y(1,1:k),'.','MarkerSize',10)
        plot(t(1:k),y(2,1:k),'.','MarkerSize',10)
        legend('Temperature 1','Temperature 2','Location','northwest')
        xlabel('Time [s]')
        ylabel('Temperature [°C]')
        subplot(2,1,2), hold on, grid on   
        stairs(t(1:k),u(1,1:k),'LineWidth',2)
        stairs(t(1:k),u(2,1:k),'LineWidth',2)
        legend('Heater 1','Heater 2','Location','northwest')
        xlabel('Time [s]')
        ylabel('Heater [%]')
        ylim([0 100]);
        drawnow;
    else
        fprintf('t = %d, y1 = %.1f C, y2 = %.1f C, u1 = %.1f, u2 = %.1f\n',t(k),y(1,k),y(2,k),u(1,k),u(2,k))
    end

    % Check if computation time did not exceed sampling time
    if toc > Ts
        warning('Computation time exceeded sampling time by %.2f s at sample %d.',toc-Ts,k)
    end
    % Waits for the begining of the new sampling interval
    pause(max(0,Ts-toc));
end

% Turns off both heaters at the end of the experiment
h1(0);
h2(0);

% Signals the end of the experiment by shutting off the LED
led(0)

disp('Temperature test complete.')

if ~rt_plot
    figure
    subplot(2,1,1), hold on, grid on   
    plot(t,y(1,:),'.','MarkerSize',10)
    plot(t,y(2,:),'.','MarkerSize',10)
    legend('Temperature 1','Temperature 2','Location','best')
    xlabel('Time [s]')
    ylabel('Temperature [°C]')
    subplot(2,1,2), hold on, grid on   
    stairs(t,u(1,:),'LineWidth',2)
    stairs(t,u(2,:),'LineWidth',2)
    legend('Heater 1','Heater 2','Location','best')
    xlabel('Time [s]')
    ylabel('Heater control [%]')
    ylim([0 100]);
end

%--------------------------------------------------------------------------

% Save figure and experiment data to file
exportgraphics(gcf,['openloop_plot_',timestr,'.png'],'Resolution',300)
save(['openloop_data_',timestr,'.mat'],'y','u','t');

%--------------------------------------------------------------------------
% End of File


