function out_para = set_paravalues(para, network, paraname, value)
%
% out_para = set_paravalues(para, network, paraname, value)
%
% This function allows the changes in the parameter struct:
% para.duration, para.threshold, para.rand_seed, para.stop_at_threshold
% para.CN.tau, para.CN.b, para.CN.sigma, para.CN.weight_init, para.CN.weight
% para.KN.tau, para.KN.b, para.KN.a, para.KN.weight_init, para.KN.sigma,
% para.KN.s, para.KN.m
% para.SN.tau, para.SN.b, para.SN.a, para.SN.sigma, para.SN.s, para.SN.m
% 
% The non-network-specific parameters are set by using [] for network.

if isempty(network)
    out_para = setfield(para, paraname, value);
else
    fields = fieldnames(getfield(para, network));
    if isempty(findcstr(fields, paraname))
        error('Unknown parameter name')
    end
    
    out_para = setfield(para, network, paraname, value);
end
end