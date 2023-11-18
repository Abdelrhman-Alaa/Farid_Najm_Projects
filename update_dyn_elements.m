function Circuit = update_dyn_elements(Circuit, x_dc)
if nargin < 2
    x_dc = 0;
end
if isfield(Circuit,'ind')
    for i = 1:length(Circuit.ind)
        if isfield(Circuit.ind{i},'Un_new')
            Circuit.ind{i}.Un = Circuit.ind{i}.Un_new;
            Circuit.ind{i}.In = Circuit.ind{i}.In_new;
        else
            if Circuit.ind{i}.pnode ~= 0
                vp = x_dc(Circuit.ind{i}.pnode);
            else
                vp = 0;
            end
            if Circuit.ind{i}.nnode ~= 0
                vn = x_dc(Circuit.ind{i}.nnode);
            else
                vn = 0;
            end
            Circuit.ind{i}.Un = vp - vn;
            Circuit.ind{i}.In = ...
                x_dc(Circuit.no_of_nodes + Circuit.no_of_group2_elements + i);
        end
    end
end
if isfield(Circuit,'cap')
    for i = 1:length(Circuit.cap)
        if isfield(Circuit.cap{i},'Un_new')
            Circuit.cap{i}.Un = Circuit.cap{i}.Un_new;
            Circuit.cap{i}.In = Circuit.cap{i}.In_new;
        else
            if Circuit.cap{i}.pnode ~= 0
                vp = x_dc(Circuit.cap{i}.pnode);
            else
                vp = 0;
            end
            if Circuit.cap{i}.nnode ~= 0
                vn = x_dc(Circuit.cap{i}.nnode);
            else
                vn = 0;
            end
            Circuit.cap{i}.Un = vp - vn;
            Circuit.cap{i}.In = 0;
        end
    end
end
end

