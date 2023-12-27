function y = tclabsim(t,x0,u,p)
    %Define constants
    sample_time = t(2);
    Cp = 500;
    A = 1e-3;
    m = 0.004;
    epsilon = 0.9;
    sigma = 5.67e-8;

    %Time of simulation
    simulation_time = t(end);

    %Define constants with function arguments
    Ta = x0;
    U = p(1);
    alpha = p(2);
    tau = p(3);

    %The profile used at the entry of the Simulink model
    u_modified = u(1,:); %Select only the data from the heater we want
    profile_matrix = [t', u_modified'];

    %Run the Simulink model
    out = sim('TCLab_model.slx', 'SrcWorkspace', 'current');

    y = out.Ts_simulated';

end