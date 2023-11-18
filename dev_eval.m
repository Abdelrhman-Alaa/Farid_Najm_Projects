function Circuit = dev_eval(Circuit,x)
%Diodes Evaluation
Dio_Isat = 1e-12;
Dio_n = 1;
Dio_VT = 0.026;
if isfield(Circuit,'dio')
    for i = 1:length(Circuit.dio)
        if Circuit.dio{i}.pnode ~= 0
            vp = x(Circuit.dio{i}.pnode);
        else
            vp = 0;
        end
        if Circuit.dio{i}.nnode ~= 0
            vn = x(Circuit.dio{i}.nnode);
        else
            vn = 0;
        end
        Circuit.dio{i}.vd = vp - vn;
        Circuit.dio{i}.Id = Circuit.dio{i}.scale * Dio_Isat * ...
            (exp(Circuit.dio{i}.vd / (Dio_n * Dio_VT)) - 1);
        Circuit.dio{i}.Geq = Circuit.dio{i}.scale * Dio_Isat ...
            / (Dio_n * Dio_VT) * exp(Circuit.dio{i}.vd / (Dio_n * Dio_VT));
        Circuit.dio{i}.Ieq = Circuit.dio{i}.Id ...
            - Circuit.dio{i}.Geq * Circuit.dio{i}.vd;
    end
end
%MOSFETs Evaluation
Mos_vth = 0.6;
Mos_lambda = 0.01;
if isfield(Circuit,'mos')
    for i = 1:length(Circuit.mos)
        if Circuit.mos{i}.gate ~= 0
            vg = x(Circuit.mos{i}.gate);
        else
            vg = 0;
        end
        if Circuit.mos{i}.drain ~= 0
            vd = x(Circuit.mos{i}.drain);
        else
            vd = 0;
        end
        if Circuit.mos{i}.source ~= 0
            vs = x(Circuit.mos{i}.source);
        else
            vs = 0;
        end
        Circuit.mos{i}.vgs = vg - vs;
        Circuit.mos{i}.vds = vd - vs;
        if Circuit.mos{i}.vgs < Mos_vth
            Circuit.mos{i}.Id = 0;
            Circuit.mos{i}.gds = 0;
            Circuit.mos{i}.gm = 0;
        elseif Circuit.mos{i}.vds < Circuit.mos{i}.vgs - Mos_vth
            Circuit.mos{i}.Id = Circuit.mos{i}.scale ...
                * ((Circuit.mos{i}.vgs - Mos_vth) * Circuit.mos{i}.vds ...
                - 0.5 * Circuit.mos{i}.vds * Circuit.mos{i}.vds);
            Circuit.mos{i}.gds = Circuit.mos{i}.scale ...
                * (Circuit.mos{i}.vgs - Mos_vth - Circuit.mos{i}.vds);
            Circuit.mos{i}.gm = Circuit.mos{i}.scale * Circuit.mos{i}.vds;
        else
            Circuit.mos{i}.Id = Circuit.mos{i}.scale / 2 ...
                * (Circuit.mos{i}.vgs - Mos_vth) * (Circuit.mos{i}.vgs - Mos_vth)...
                * (1 + Mos_lambda * Circuit.mos{i}.vds);
            Circuit.mos{i}.gds = Circuit.mos{i}.scale / 2 * Mos_lambda ...
                * (Circuit.mos{i}.vgs - Mos_vth) * (Circuit.mos{i}.vgs - Mos_vth);
            Circuit.mos{i}.gm = Circuit.mos{i}.scale ...
                * (Circuit.mos{i}.vgs - Mos_vth) ...
                * (1 + Mos_lambda * Circuit.mos{i}.vds);
        end
        Circuit.mos{i}.Ieq = Circuit.mos{i}.Id - ...
                Circuit.mos{i}.gm * Circuit.mos{i}.vgs - ...
                Circuit.mos{i}.gds * Circuit.mos{i}.vds;
    end
end
%BJTs Evaluation
Bjt_alpha_F = 0.99;
Bjt_alpha_R = 0.02;
Bjt_Ies = 2e-14;
Bjt_Ics = 99e-14;
Bjt_VT = 0.026;
if isfield(Circuit,'bjt')
    for i = 1:length(Circuit.bjt)
        if Circuit.bjt{i}.base ~= 0
            vb = x(Circuit.bjt{i}.base);
        else
            vb = 0;
        end
        if Circuit.bjt{i}.collector ~= 0
            vc = x(Circuit.bjt{i}.collector);
        else
            vc = 0;
        end
        if Circuit.bjt{i}.emitter ~= 0
            ve = x(Circuit.bjt{i}.emitter);
        else
            ve = 0;
        end
        Circuit.bjt{i}.vbe = vb - ve;
        Circuit.bjt{i}.vbc = vb - vc;
        Circuit.bjt{i}.Ie = -Bjt_Ies * (exp(Circuit.bjt{i}.vbe/Bjt_VT) - 1)...
            + Bjt_alpha_R * Bjt_Ics * (exp(Circuit.bjt{i}.vbc/Bjt_VT) - 1);
        Circuit.bjt{i}.Ic = Bjt_alpha_F * Bjt_Ies ...
            * (exp(Circuit.bjt{i}.vbe/Bjt_VT) - 1)...
            - Bjt_Ics * (exp(Circuit.bjt{i}.vbc/Bjt_VT) - 1);
        Circuit.bjt{i}.gee = Bjt_Ies / Bjt_VT * exp(Circuit.bjt{i}.vbe/Bjt_VT);
        Circuit.bjt{i}.gce = Bjt_alpha_F * Circuit.bjt{i}.gee;
        Circuit.bjt{i}.gcc = Bjt_Ics / Bjt_VT * exp(Circuit.bjt{i}.vbc/Bjt_VT);
        Circuit.bjt{i}.gec = Bjt_alpha_R * Circuit.bjt{i}.gcc;
        Circuit.bjt{i}.Ieeq = Circuit.bjt{i}.Ie ...
            + Circuit.bjt{i}.gee * Circuit.bjt{i}.vbe ...
            - Circuit.bjt{i}.gec * Circuit.bjt{i}.vbc;
        Circuit.bjt{i}.Iceq = Circuit.bjt{i}.Ic ...
            - Circuit.bjt{i}.gce * Circuit.bjt{i}.vbe ...
            + Circuit.bjt{i}.gcc * Circuit.bjt{i}.vbc;
    end
end