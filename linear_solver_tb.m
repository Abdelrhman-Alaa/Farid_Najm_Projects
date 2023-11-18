function x = linear_solver_tb(netlist)
    Circuit = parser(netlist);
    [G,RHS] = linear_stamper(Circuit);
    x = G \ RHS;
end

