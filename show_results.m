function show_results(RT, y_KN, y_CN, titel, saim_type, plot_flag)

set_plot_default;

iptsetpref('ImshowBorder', 'tight')
iptsetpref('ImshowAxesVisible','on')

hf = figure;
set(hf, 'position', [1 1 770 450]);

if plot_flag == 0
    
    ax = subplot_tight(2,6,1); axis([0 1 0 1]);
    
    text(0.1,0.5, ['Knowledge','\newline','Network'], 'horizontal', 'center', 'fontweight', 'bold', 'rotation', 90); axis off
    
    
    ax = subplot_tight(2,6,7); axis([0 1 0 1]);
    text(0.1,0.5, ['Focus of','\newline', 'Attention'], 'horizontal', 'center', 'fontweight', 'bold', 'rotation', 90); axis off
    
    if RT < 10
        [RT d1 d2] = size(y_CN);
    end
    steps = [1 floor(RT/4) 2*floor(RT/4) 3*floor(RT/4) RT];
    
    if saim_type == 2
        h_foa = imshow_foa(2,6,8, y_CN,steps, [0.7 0.8]);
    else
        h_foa = imshow_foa(2,6,8, y_CN,steps, [0.4 1]);
        
    end
    
    
    ax1 = subplot_tight(2,6,[2 6]);
    ax1.ActivePositionProperty = 'outerposition';
    
    plot_know( y_KN, 'symbols', '-','--', 'legends', 'cross', 'two', 'step', 0.005);
    xlim('manual');
    ylim('manual');
    if saim_type == 2
        ylim([0 1]);
%        ylim([0.3 0.7]);
    else
        ylim([0 1]);
        
    end
    
    ax1 = suptitle(titel);
    set(ax1, 'fontweight', 'bold');
    
end



end