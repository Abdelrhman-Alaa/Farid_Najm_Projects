function Hg = nonlinear_current_vector(Circuit)
dim = Circuit.no_of_nodes + Circuit.no_of_group2_elements;
Hg = zeros(dim,1);
if isfield(Circuit,'dio')
    for i = 1:length(Circuit.dio)
        if Circuit.dio{i}.pnode ~= 0
            Hg(Circuit.dio{i}.pnode) = Hg(Circuit.dio{i}.pnode) + Circuit.dio{i}.Id;
        end
        if Circuit.dio{i}.nnode ~= 0
            Hg(Circuit.dio{i}.nnode) = Hg(Circuit.dio{i}.nnode) - Circuit.dio{i}.Id;
        end
    end
end
if isfield(Circuit,'mos')
    for i = 1:length(Circuit.mos)
        if Circuit.mos{i}.drain ~= 0
            Hg(Circuit.mos{i}.drain) = Hg(Circuit.mos{i}.drain) + Circuit.mos{i}.Id;
        end
        if Circuit.mos{i}.source ~= 0
            Hg(Circuit.mos{i}.source) = Hg(Circuit.mos{i}.source) - Circuit.mos{i}.Id;
        end
    end
end
if isfield(Circuit,'bjt')
    for i = 1:length(Circuit.bjt)
        if Circuit.bjt{i}.collector ~= 0
            Hg(Circuit.bjt{i}.collector) = Hg(Circuit.bjt{i}.collector) + Circuit.bjt{i}.Ic;
        end
        if Circuit.bjt{i}.emitter ~= 0
            Hg(Circuit.bjt{i}.emitter) = Hg(Circuit.bjt{i}.emitter) + Circuit.bjt{i}.Ie;
        end
        if Circuit.bjt{i}.base ~= 0
            Hg(Circuit.bjt{i}.base) = Hg(Circuit.bjt{i}.base) ...
                - Circuit.bjt{i}.Ie - Circuit.bjt{i}.Ic;
        end
    end
end