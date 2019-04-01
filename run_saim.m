function [RT, node, y_KN, y_CN, input_SN, input_CN, input_KN, y_SN]= run_saim(saim_type, para, templates, input_image, seed)
%
% [RT, node, y_KN, y_CN, y_SN, input_SN, input_CN, input_KN] = run_saim(saim_type, para, templates, input_image, seed)
%
% interface for both models, PE-SAIM and EM-SAIM
%
%   saim_type: selects the mmodel (1: EM-SAIM, 2: PE-SAIM)
%   para: struct with allparameters
%   templates: object templates
%   input_image: input image
%   seed: seed for random number generator
%
if saim_type == 1
    [RT, node, y_KN, y_CN, y_SN, input_SN, input_CN, input_KN] = run_EM_SAIM(para, templates, input_image, seed);
end
if saim_type == 2
    [RT, node, y_KN, y_CN, y_SN, input_SN, input_CN, input_KN] = run_PE_SAIM(para, templates, input_image, seed);
end
