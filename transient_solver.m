clear all;
netlist='netlists/Tran_Circuit.txt';
Tstop = 20e-9;
reltol = 0.001;
vabstol = 1e-3;
iabstol = 1e-6;
maxiter = 20;
min_timestep = 1e-12;
Circuit = parser(netlist);
x_dc = DCSolver(Circuit);
accepted_timesteps = 0;
rejected_timesteps = 0;
J_gmin = diag(1e-15*ones(1,Circuit.no_of_nodes));
t = zeros(1,1000);
x = cell(1,1000);
h = min_timestep;
t(1:2) = [0 h];
x{1} = x_dc(1:Circuit.no_of_nodes + Circuit.no_of_group2_elements);
t_i = 2;
Circuit = update_dyn_elements(Circuit, x_dc);
endtime = false;
last_time_point = false;
while ~endtime
    Circuit.vsrc{1}.value = 3 * exp(-t(t_i)/2e-9);
    %h = t(t_i) - t(t_i - 1);
    [G_static, RHS_static] = linear_stamper(Circuit);
    [G_dynamic, RHS_dynamic, Circuit] = dyn_linear_stamper(Circuit, 'TRAN', h, x{t_i-1});
    G = G_static + G_dynamic;
    RHS = RHS_static + RHS_dynamic;
    %G(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) = ...
    %G(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) + J_gmin;
    x_new = x{t_i - 1};
    Circuit = dev_eval(Circuit,x_new);
    for i = 1:maxiter
        x_old = x_new;
        [G_linearized, RHS_linearized] = nonlinear_stamper(Circuit);
        Js = G + G_linearized;
        RHS_total = RHS + RHS_linearized;
        x_new = Js \ RHS_total;
        SN = x_new - x_old;
        S = 1.3 / 16 * sign(SN) .* log(1 + 16 * abs(SN));
        x_new = x_old + S;
        Circuit = dev_eval(Circuit,x_new);
        Hg = nonlinear_current_vector(Circuit);
        if i == 1
            Residual = G*x_new + Hg - RHS;
            Residual_i_1 = norm(Residual(1:Circuit.no_of_nodes));
            Residual_v_1 = norm(Residual(Circuit.no_of_nodes+1:end));
        end
        dx_v = norm(x_new(1:Circuit.no_of_nodes) - x_old(1:Circuit.no_of_nodes));
        dx_i = norm(x_new(Circuit.no_of_nodes+1:end) ...
            - x_old(Circuit.no_of_nodes+1:end));
        if norm(x_new) > norm(x_old)
            xmax = x_new;
        else
            xmax = x_old;
        end
        xmax_v = norm(xmax(1:Circuit.no_of_nodes));
        xmax_i = norm(xmax(Circuit.no_of_nodes+1:end));
        Residual = G*x_new + Hg - RHS;
        Residual_i = norm(Residual(1:Circuit.no_of_nodes));
        Residual_v = norm(Residual(Circuit.no_of_nodes+1:end));
        if dx_v < reltol * xmax_v + vabstol && dx_i < reltol * xmax_i + iabstol ...
                && Residual_v < reltol * Residual_v_1 + vabstol ...
                && Residual_i < reltol * Residual_i_1 + iabstol
            newton_converged = true;
            break;
        end
        if (i == maxiter)
            fprintf('Nonconvergence in TRAN, t=%i', t(t_i));
            newton_converged = false;
        end
    end
    if newton_converged == false
        rejected_timesteps = rejected_timesteps + 1;
        h = h / 2;
        if h < min_timestep
            error ('TSTS at t=%i', t(t_i));
        end
    elseif t_i > 3
        PLTE = estimate_PLTE(t, t_i,x,x_new);
        PLTE_v = norm(PLTE(1:Circuit.no_of_nodes));
        PLTE_i = norm(PLTE(Circuit.no_of_nodes+1:end));
        if PLTE_v > reltol * xmax_v + vabstol ...
                || PLTE_i > reltol * xmax_i + iabstol
            rejected_timesteps = rejected_timesteps + 1;
            h = h / 2;
            if h < min_timestep
                error ('TSTS at t=%i', t(t_i));
            end
        elseif PLTE_v < 1e-5 * xmax_v + 10e-6 ...
                && PLTE_i > 1e-5 * xmax_i + 10e-9
            
            accepted_timesteps = accepted_timesteps + 1;
            x{t_i} = x_new;
            t_i = t_i + 1;
            Circuit = update_dyn_elements(Circuit);
            h = h * 2;
        else
            accepted_timesteps = accepted_timesteps + 1;
            x{t_i} = x_new;
            t_i = t_i + 1;
            Circuit = update_dyn_elements(Circuit);
        end
    else
        accepted_timesteps = accepted_timesteps + 1;
        x{t_i} = x_new;
        t_i = t_i + 1;
        Circuit = update_dyn_elements(Circuit);
    end
    if t_i > length(t)
        t = [t zeros(1,length(t))];
        x = [x cell(1,length(x))];
    end
    t(t_i) = t(t_i - 1) + h;
    if t(t_i) > Tstop
        if ~last_time_point
            t(t_i) = Tstop;
            last_time_point = true;
        else
            endtime = true;
        end
    end
end
tran_solution.time = t(1:accepted_timesteps + 1);
tran_solution.vars = x(1:accepted_timesteps + 1);
node1 = zeros(1,length(tran_solution.time));
node4 = zeros(1,length(tran_solution.time));
node5 = zeros(1,length(tran_solution.time));
for i = 1:length(tran_solution.time)
    node1(i) = tran_solution.vars{i}(1);
    node4(i) = tran_solution.vars{i}(4);
    node5(i) = tran_solution.vars{i}(5);
end
plot(tran_solution.time,node1,tran_solution.time,node4,tran_solution.time,node5);
grid on;
title('Solution for Problem 5.13');
xlabel('Time (seconds)');
ylabel('Voltage (volt)');
legend('Node 1', 'Node 4', 'Node 5');
