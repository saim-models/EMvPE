function [ output_args ] = imshow_foa(n, m, start_index, foa, steps, limits)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if ~exist('limits')
    limits = [];
end

%subplot(n,m,1);

for i=1:5
%    subaxis(n,m,[start_index + i-1 start_index + i-1+2*m], 'sh', 0.01, 'sv', 0.01, 'padding', 0, 'margin', 0.01);
%    subplot(n,m,[start_index + i-1 start_index + i-1+2*m]);
    subplot_tight(n,m,start_index+ i -1);
    h=imshow(1-squeeze(foa(steps(i),:,:)), limits);
        set(gca,'ytick',[]);
    set(gca,'xtick',[]);
%    set(gca,'XTickLabel','');
%    set(gca,'YTickLabel','');
    xlabel(sprintf('%d',steps(i)) );
end
output_args = gca;
end

