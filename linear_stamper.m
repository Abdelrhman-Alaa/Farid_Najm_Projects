function [G, RHS] = linear_stamper(Circuit)
dim = Circuit.no_of_nodes + Circuit.no_of_group2_elements;
G = zeros(dim,dim);
RHS = zeros(dim,1);
% Resistors stamp
if isfield(Circuit,'res')
    for element = Circuit.res
        if isfield(element{1}, 'group2_id')
            group2_dim = Circuit.no_of_nodes + element{1}.group2_id;
            if element{1}.pnode ~= 0
                G(element{1}.pnode, group2_dim) = 1;
                G(group2_dim, element{1}.pnode) = 1;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode, group2_dim) = -1;
                G(group2_dim, element{1}.nnode) = -1;
            end
            G(group2_dim, group2_dim) = -element{1}.value;
        else
            if element{1}.pnode ~= 0
                G(element{1}.pnode,element{1}.pnode) = ...
                    G(element{1}.pnode,element{1}.pnode) + 1/element{1}.value;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode,element{1}.nnode) = ...
                    G(element{1}.nnode,element{1}.nnode) + 1/element{1}.value;
            end
            if element{1}.nnode ~= 0 && element{1}.nnode ~= 0
                G(element{1}.pnode,element{1}.nnode) = ...
                    G(element{1}.pnode,element{1}.nnode) - 1/element{1}.value;
                G(element{1}.nnode,element{1}.pnode) = ...
                    G(element{1}.nnode,element{1}.pnode) - 1/element{1}.value;
            end
        end
    end
end
%Isrc stamp
if isfield(Circuit,'isrc')
    for element = Circuit.isrc
        if isfield(element{1}, 'group2_id')
            group2_dim = Circuit.no_of_nodes + element{1}.group2_id;
            if element{1}.pnode ~= 0
                G(element{1}.pnode, group2_dim) = 1;
            end
            if element{1}.nnode ~= 0
                G(element{1}.nnode, group2_dim) = -1;
            end
            G(group2_dim, group2_dim) = 1;
            RHS(group2_dim) = element{1}.value;
        else
            if element{1}.pnode ~= 0
                RHS(element{1}.pnode) = RHS(element{1}.pnode) - element{1}.value;
            end
            if element{1}.nnode ~= 0
                RHS(element{1}.nnode) = RHS(element{1}.nnode) + element{1}.value;
            end
        end
    end
end
%Vsrc stamp
if isfield(Circuit,'vsrc')
    for element = Circuit.vsrc
        group2_dim = Circuit.no_of_nodes + element{1}.group2_id;
        if element{1}.pnode ~= 0
            G(element{1}.pnode, group2_dim) = 1;
            G(group2_dim, element{1}.pnode) = 1;
        end
        if element{1}.nnode ~= 0
            G(element{1}.nnode, group2_dim) = -1;
            G(group2_dim, element{1}.nnode) = -1;
        end
        RHS(group2_dim) = element{1}.value;
    end
end