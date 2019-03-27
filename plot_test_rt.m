function h = plot_test_rt(rt_ct, rt_c, rt_t, n_ct, n_c, n_t)
%
% h = plot_test_rt(rt_ct, rt_c, rt_t, n_ct, n_c, n_t)
%

if exist('n_c')
    i_c = find(n_c == 1);
    rt_c = rt_c(i_c);
end

if exist('n_t')
    i_t = find(n_t == 2);
    rt_t = rt_t(i_t);
end



set_plot_default

subplot(2,1,1);
m_ct = mean(rt_ct);
m_c = mean(rt_c);
m_t = mean(rt_t);

s_ct = std(rt_ct) / sqrt(length(rt_ct));
s_c = std(rt_c) / sqrt(length(rt_c));
s_t = std(rt_t) / sqrt(length(rt_t));

errorbar([0.5 1.5 2.5], [m_ct m_c m_t], [s_ct s_c s_t],'+-k');
ylabel('reaction time');
%xlabel('display')
xlim([0 3]);
xticks([0.5 1.5 2.5]);
%ticklabels({' ', ' ', ' '});
xticklabels({'cross two', 'cross', 'two'});

[h, p, CI stats] = ttest2(rt_ct, rt_c);
fprintf(1,'ct vs c: t(%d)=%.2f; p = %.3f\n', stats.df, stats.tstat, p);
[h, p, CI stats] = ttest2(rt_ct, rt_t);
fprintf(1,'ct vs t: t(%d)=%.2f; p = %.3f\n', stats.df, stats.tstat, p);
[h, p, CI stats] = ttest2(rt_c, rt_t);
fprintf(1,'t vs c: t(%d)=%.2f; p = %.3f\n', stats.df, stats.tstat, p);


%NOT TRUE ERROS ANYWAY. THEY FAIL TO PASS THE THRESHOLD
% subplot(2,1,2);
% 
% acc_ct = length(i_ct) / length(n_ct) * 100;
% acc_c = length(i_c) / length(n_c) *100;
% acc_t = length(i_t) / length(n_t) *100;
% 
% bar([0.5 1.5 2.5], [acc_ct acc_c acc_t], 'k');
% ylabel('accuarcy (%)');
% xlabel('Stimulus')
% xlim([0 3]);
% xticks([0.5 1.5 2.5]);
% xticklabels({'cross two', 'cross', 'two'});

end