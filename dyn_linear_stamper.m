function [G, RHS, Circuit] = dyn_linear_stamper(Circuit, mode, h, x)
dim = Circuit.no_of_nodes + Circuit.no_of_group2_elements;
G = zeros(dim,dim);
RHS = zeros(dim,1);
if strcmp(mode,'DC')
    % Inductor stamp in DC
    if isfield(Circuit,'ind')
        L_dim = Circuit.no_of_nodes ...
            + Circuit.no_of_group2_elements ...
            - length(Circuit.ind) ...
            + 1;
        for element = Circuit.ind
            group2_dim = L_dim;
            if element{1}.pnode ~= 0
                G(element{1}.pnode, group2_dim) = 1;
                G(group2_dim, element{1}.pnode) = 1;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode, group2_dim) = -1;
                G(group2_dim, element{1}.nnode) = -1;
            end
            L_dim = L_dim + 1;
        end
    end
else
    if isfield(Circuit,'ind')
        ind_i = 1;
        for element = Circuit.ind
            if element{1}.pnode ~= 0
                vp = x(element{1}.pnode);
            else
                vp = 0;
            end
            if element{1}.nnode ~= 0
                vn = x(element{1}.nnode);
            else
                vn = 0;
            end
            Circuit.ind{ind_i}.Un_new = vp - vn;  
            Geq = h / 2 / element{1}.value;
            Circuit.ind{ind_i}.In_new  = Circuit.ind{ind_i}.In ...
                + Geq * (Circuit.ind{ind_i}.Un_new + Circuit.ind{ind_i}.Un);
            Ieq = Circuit.ind{ind_i}.In_new + Geq * Circuit.ind{ind_i}.Un_new;
            if element{1}.pnode ~= 0
                G(element{1}.pnode, element{1}.pnode) = ...
                    G(element{1}.pnode, element{1}.pnode) + Geq;
                RHS(element{1}.pnode) = -Ieq;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode, element{1}.nnode) = ...
                    G(element{1}.nnode, element{1}.nnode) + Geq;
                RHS(element{1}.nnode) = Ieq;
            end
            if element{1}.pnode ~= 0 && element{1}.nnode ~= 0
                G(element{1}.pnode, element{1}.nnode) = ...
                    G(element{1}.pnode, element{1}.nnode) - Geq;
                G(element{1}.nnode, element{1}.pnode) = ...
                    G(element{1}.nnode, element{1}.pnode) - Geq;
            end
            ind_i = ind_i + 1;
        end
    end
    if isfield(Circuit,'cap')
        cap_i = 1;
        for element = Circuit.cap
            if element{1}.pnode ~= 0
                vp = x(element{1}.pnode);
            else
                vp = 0;
            end
            if element{1}.nnode ~= 0
                vn = x(element{1}.nnode);
            else
                vn = 0;
            end
            Circuit.cap{cap_i}.Un_new = vp - vn;  
            Geq = 2 * element{1}.value / h;
            Circuit.cap{cap_i}.In_new  = -Circuit.cap{cap_i}.In ...
                + Geq * (Circuit.cap{cap_i}.Un_new - Circuit.cap{cap_i}.Un);
            Ieq = Circuit.cap{cap_i}.In_new + Geq * Circuit.cap{cap_i}.Un_new;
            if element{1}.pnode ~= 0
                G(element{1}.pnode, element{1}.pnode) = ...
                    G(element{1}.pnode, element{1}.pnode) + Geq;
                RHS(element{1}.pnode) = Ieq;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode, element{1}.nnode) = ...
                    G(element{1}.nnode, element{1}.nnode) + Geq;
                RHS(element{1}.nnode) = -Ieq;
            end
            if element{1}.pnode ~= 0 && element{1}.nnode ~= 0
                G(element{1}.pnode, element{1}.nnode) = ...
                    G(element{1}.pnode, element{1}.nnode) - Geq;
                G(element{1}.nnode, element{1}.pnode) = ...
                    G(element{1}.nnode, element{1}.pnode) - Geq;
            end
            cap_i = cap_i + 1;
        end
    end
end