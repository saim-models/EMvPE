function filename = identifier2filename(model,identifier)
%
% filename = identifier2filename(model,identifier)
%
if model == 1
    filename = sprintf('EM_simu_%s', identifier);
end
if model ==2
    filename = sprintf('PE_simu_%s', identifier);
end

end

