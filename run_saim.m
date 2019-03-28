function [RT node y_KN y_CN input_SN input_CN input_KN y_SN]= run_saim(saim_type, para, templates, input_image, seed)

if saim_type == 1
    [RT node y_KN y_CN y_SN input_SN input_CN input_KN] = run_EM_SAIM(para, templates, input_image, seed);
end
if saim_type == 2
    [RT node y_KN y_CN y_SN input_SN input_CN input_KN] = run_PE_SAIM(para, templates, input_image, seed);
end
