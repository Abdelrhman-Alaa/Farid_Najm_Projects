function Circuit = parser(netlist)
% Parser function supports only independent sources, MOSFETs, BJTs, diodes,
% linear resistors, linear capacitors and linear inductors
% Parser is case-insenstive
% All nodes should be non-negative integers 1,2,3...
% Values of elements should be given in SI units (Volt, Ampere, Ohm, Farad,
% or Henry)
% Ground node name: 0
% MOSFET: MN<int>/MP<int> <node.D> <node.G> <node.S> [<scale factor value>]
% BJT: QN<int>/QP<int> <node.C> <node.B> <node.E> [<value>]
% Diode: D<int> <node.+> <node.-> [<value>]
% Resistor: R<int> <node.+> <node.-> <value> [G2]
% Capacitor: C<int> <node.+> <node.-> <value> [G2]
% Inductor: L<int> <node.+> <node.-> <value>
% Voltage source: V<int> node.+ node.- <value>
% Current source: I<int> node.+ node.- <value> [G2]

fid = fopen(netlist,'rt');
if fid < 0
    error('error opening netlist.txt');
end

mos_i = 1;
bjt_i = 1;
dio_i = 1;
res_i = 1;
cap_i = 1;
ind_i = 1;
vsrc_i = 1;
isrc_i = 1;
max_node = 0;
group2_i = 1;
while true
    oneline = upper(fgetl(fid));
    if ~ischar(oneline)
        break;
    end
    if isempty(oneline)
        continue;
    end
    line_splitted = strsplit(strtrim(oneline));
    identifier = line_splitted{1}(1);
    if identifier == 'M'
        Circuit.mos{mos_i}.name = line_splitted{1};
        Circuit.mos{mos_i}.drain = str2double(line_splitted{2});
        Circuit.mos{mos_i}.gate = str2double(line_splitted{3});
        Circuit.mos{mos_i}.source = str2double(line_splitted{4});
        if length(line_splitted) > 4
            Circuit.mos{mos_i}.scale = str2double(line_splitted{5});
        else
            Circuit.mos{mos_i}.scale = 0.5e-3;
        end
        max_node = max([max_node, Circuit.mos{mos_i}.drain,...
            Circuit.mos{mos_i}.gate, Circuit.mos{mos_i}.source]);
        mos_i = mos_i + 1;
    elseif identifier == 'Q'
        Circuit.bjt{bjt_i}.name = line_splitted{1};
        Circuit.bjt{bjt_i}.collector = str2double(line_splitted{2});
        Circuit.bjt{bjt_i}.base = str2double(line_splitted{3});
        Circuit.bjt{bjt_i}.emitter = str2double(line_splitted{4});
        if length(line_splitted) > 4
            Circuit.bjt{bjt_i}.scale = str2double(line_splitted{5});
        end
        max_node = max([max_node, Circuit.bjt{bjt_i}.collector,...
            Circuit.bjt{bjt_i}.base, Circuit.bjt{bjt_i}.emitter]);
        bjt_i = bjt_i + 1;
    elseif identifier == 'D'
        Circuit.dio{dio_i}.name = line_splitted{1};
        Circuit.dio{dio_i}.pnode = str2double(line_splitted{2});
        Circuit.dio{dio_i}.nnode = str2double(line_splitted{3});
        if length(line_splitted) > 3
            Circuit.dio{dio_i}.scale = str2double(line_splitted{4});
        else
            Circuit.dio{dio_i}.scale = 1;
        end
        max_node = max([max_node, Circuit.dio{dio_i}.pnode,...
            Circuit.dio{dio_i}.nnode]);
        dio_i = dio_i + 1;
    elseif identifier == 'R'
        Circuit.res{res_i}.name = line_splitted{1};
        Circuit.res{res_i}.pnode = str2double(line_splitted{2});
        Circuit.res{res_i}.nnode = str2double(line_splitted{3});
        Circuit.res{res_i}.value = str2double(line_splitted{4});
        if length(line_splitted) > 4 && strcmp(line_splitted{5}, 'G2')
            Circuit.res{res_i}.group2_id = group2_i;
            group2_i = group2_i + 1;
        end
        max_node = max([max_node, Circuit.res{res_i}.pnode,...
            Circuit.res{res_i}.nnode]);
        res_i = res_i + 1;
    elseif identifier == 'C'
        Circuit.cap{cap_i}.name = line_splitted{1};
        Circuit.cap{cap_i}.pnode = str2double(line_splitted{2});
        Circuit.cap{cap_i}.nnode = str2double(line_splitted{3});
        Circuit.cap{cap_i}.value = str2double(line_splitted{4});
        if length(line_splitted) > 4 && strcmp(line_splitted{5}, 'G2')
            Circuit.cap{cap_i}.group2_id = group2_i;
            group2_i = group2_i + 1;
        end
        max_node = max([max_node, Circuit.cap{cap_i}.pnode,...
            Circuit.cap{cap_i}.nnode]);
        cap_i = cap_i + 1;
    elseif identifier == 'L'
        Circuit.ind{ind_i}.name = line_splitted{1};
        Circuit.ind{ind_i}.pnode = str2double(line_splitted{2});
        Circuit.ind{ind_i}.nnode = str2double(line_splitted{3});
        Circuit.ind{ind_i}.value = str2double(line_splitted{4});
        max_node = max([max_node, Circuit.ind{ind_i}.pnode,...
            Circuit.ind{ind_i}.nnode]);
        ind_i = ind_i + 1;
    elseif identifier == 'V'
        Circuit.vsrc{vsrc_i}.name = line_splitted{1};
        Circuit.vsrc{vsrc_i}.pnode = str2double(line_splitted{2});
        Circuit.vsrc{vsrc_i}.nnode = str2double(line_splitted{3});
        Circuit.vsrc{vsrc_i}.value = str2double(line_splitted{4});
        Circuit.vsrc{vsrc_i}.group2_id = group2_i;
        group2_i = group2_i + 1;
        max_node = max([max_node, Circuit.vsrc{vsrc_i}.pnode,...
            Circuit.vsrc{vsrc_i}.nnode]);
        vsrc_i = vsrc_i + 1;
    elseif identifier == 'I'
        Circuit.isrc{isrc_i}.name = line_splitted{1};
        Circuit.isrc{isrc_i}.pnode = str2double(line_splitted{2});
        Circuit.isrc{isrc_i}.nnode = str2double(line_splitted{3});
        Circuit.isrc{isrc_i}.value = str2double(line_splitted{4});
        if length(line_splitted) > 4 && strcmp(line_splitted{5}, 'G2')
            Circuit.isrc{isrc_i}.group2_id = group2_i;
            group2_i = group2_i + 1;
        end
        max_node = max([max_node, Circuit.isrc{isrc_i}.pnode,...
            Circuit.isrc{isrc_i}.nnode]);
        isrc_i = isrc_i + 1;
    else
        error('Not supported syntax: "%s"',oneline);
    end
end
Circuit.no_of_nodes = max_node;
Circuit.no_of_group2_elements = group2_i - 1;