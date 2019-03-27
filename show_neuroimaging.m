function show_neuroimaging(input_SN, input_CN, input_KN, output_SN, output_CN, output_KN, saim_type, tagged, simu_name)
%
% show_neuroimaging(input_SN, input_CN, input_KN, output_SN, output_CN, output_KN, saim_type, tagged, simu_name)
% plots figure 7 and 8 in Abadi et al.
%
% model: 1 = EM; 2 = PE
% tagged: 0 = sum of input and output activation of the network  (Figure 7)
%         1 = input activation (Figure 8)


set_plot_default();

iptsetpref('ImshowBorder', 'tight')
iptsetpref('ImshowAxesVisible','on')

% Selection network
[t d1 d2] = size(input_SN);
if tagged == 0
    figure('Name', 'Abadi et al.: Figure 7');
    h3 = subplot(2,1,2);
    plot(1:t,sum(input_SN(1:t, :)+ output_SN(1:t, :),2), '-k');
else
    figure('Name', 'Abadi et al.: Figure 8');
    h3 = subplot(2,1,2);
    step = 3;
    plot(2:step:t,sum(input_SN(2:step:t,:),2), '-k'); hold
    
end
set(gca, 'yticklabel', []);
axis('tight');
title(h3, 'Selection Network');
xlabel('time');

% knowledge network
if tagged == 0
    h1 = subplot(2,1,1);
    plot(1:t,sum(input_KN(1:t, :)+ output_KN(1:t, :),2), '-k');
    
else
    h1 = subplot(2,1,1);
    step = 3;
    plot(2:step:t,sum(input_KN(2:step:t,:),2), '-k'); hold
   
end
axis('tight');
title(h1, 'Knowledge Network');
set(gca, 'yticklabel', []);
set(gca, 'xticklabel', []);


p1=get(h1,'position');
p2=get(h3,'position');
height=p1(2)+p1(4)-p2(2);
h3=axes('position',[p2(1) p2(2) p2(3) height],'visible','off');

% if saim_type == 1
%     co = sprintf('print -depsc plot_em_input_%s', simu_name);
%     eval(co);
% end
%
%
% if saim_type == 2
%     co = sprintf('print -depsc plot_pe_input_%s', simu_name);
%     eval(co);
% end


end