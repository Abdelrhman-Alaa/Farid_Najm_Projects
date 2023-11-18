clear all;
netlist = 'DCCircuit.txt';
reltol = 0.001;
vabstol = 1e-3;
iabstol = 1e-6;
Circuit = parser(netlist);
x0 = zeros(Circuit.no_of_nodes + Circuit.no_of_group2_elements, 1);
Circuit = dev_eval(Circuit,x0);
%x = cell(1,20);
%x_linear = cell(1,20);
%x{1} = x0;
%ord_of_conv = zeros(1,20);
x = x0;
x_sweep = zeros(length(0:0.01:3),1);
num_iter = zeros(length(0:0.01:3),1);
j = 1;
J_gmin = diag(1e-15*ones(1,Circuit.no_of_nodes));
for v = 0:0.01:3
    Circuit.vsrc{1}.value = v;
    [G, RHS] = linear_stamper(Circuit);
    %G(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) = ...
        %G(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) + J_gmin;        
    for i = 1:20
        x_old = x;
        [G_linearized, RHS_linearized] = nonlinear_stamper(Circuit);
        Js = G + G_linearized;
        RHS_total = RHS + RHS_linearized;
        if cond(Js) > 1e15
            Js(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) = ...
                Js(1:Circuit.no_of_nodes,1:Circuit.no_of_nodes) + J_gmin;
        end
        x = Js \ RHS_total;
        SN = x - x_old;
        S = 1.3 / 16 * sign(SN) .* log(1 + 16 * abs(SN));
        x = x_old + S;
        Circuit = dev_eval(Circuit,x);
        Hg = nonlinear_current_vector(Circuit);
        if i == 1
            %bool_big_step = bool_big_step & (x{1} > eps);
            Residual = G*x + Hg - RHS;
            Residual_i_1 = norm(Residual(1:Circuit.no_of_nodes));
            Residual_v_1 = norm(Residual(Circuit.no_of_nodes+1:end));
        end
        %x{i} = x_linear{i} .* (1 - bool_big_step) + ...
        %    bool_big_step .* (x{i - 1} + sign(x_linear{i} - x{i - 1}) .* max_step);

        dx_v = norm(x(1:Circuit.no_of_nodes) - x_old(1:Circuit.no_of_nodes));
        dx_i = norm(x(Circuit.no_of_nodes+1:end) ...
            - x_old(Circuit.no_of_nodes+1:end));
        if norm(x) > norm(x_old)
            xmax = x;
        else
            xmax = x_old;
        end
        xmax_v = norm(xmax(1:Circuit.no_of_nodes));
        xmax_i = norm(xmax(Circuit.no_of_nodes+1:end));
        Residual = G*x + Hg - RHS;
        Residual_i = norm(Residual(1:Circuit.no_of_nodes));
        Residual_v = norm(Residual(Circuit.no_of_nodes+1:end));
        %if i > 3
        %    ord_of_conv(i - 3) = log(norm(x{i} - x{i-1})/norm(x{i-1} - x{i-2})) ...
        %        / log(norm(x{i-1} - x{i-2})/norm(x{i-2} - x{i-3}));
        %end
        if dx_v < reltol * xmax_v + vabstol && dx_i < reltol * xmax_i + iabstol ...
                && Residual_v < reltol * Residual_v_1 + vabstol ...
                && Residual_i < reltol * Residual_i_1 + iabstol 
        %   Circuit = dev_eval(Circuit,models,x{i}); 
           break;
        end
    end
    x_sweep(j) = x(7);
    num_iter(j) = i;
    j = j + 1;
end
plot(0:0.01:3,x_sweep);
axis([0 3 0 3.2]);
axis([0 3 -0.2 3.2]);
xlabel('Voltage at Node 1 (V)');
ylabel('Voltage at Node 7 (V)');
title('Solution of problem 4.8');
grid on;
grid minor;