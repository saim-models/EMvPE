function show_image_temp(im1, im2, im3, temp1, temp2)

set_plot_default;

iptsetpref('ImshowBorder', 'tight')
iptsetpref('ImshowAxesVisible','on')

figure('position', [1 1 784 222]);




ax1 = subplot_tight(2,7,[1 9], [0.07]);
ax1.ActivePositionProperty = 'outerposition';
imshow(1-im1,[]);
xticks([])
yticks([])
title(' ')


ax1 = subplot_tight(2,7,[3 11], [0.07]);
ax1.ActivePositionProperty = 'outerposition';

imshow(1-im2,[]);
xticks([])
yticks([])
ax1 = title('Input images');
fs = get(ax1, 'fontsize');

ax1 = subplot_tight(2,7,[5 13], [0.07]);
ax1.ActivePositionProperty = 'outerposition';
imshow(1-im3,[]);
xticks([])
yticks([])
title(' ')

ax1 = subplot_tight(2,7,7, [0.07]);
ax1.ActivePositionProperty = 'outerposition';


imshow(1-temp1,[]);
xticks([])
yticks([])

text(4,8.25, 'cross', 'horizontal', 'center')

title('Templates', 'fontsize', fs)


ax1 = subplot_tight(2,7,14, [0.07]);
ax1.ActivePositionProperty = 'outerposition';

imshow(1-temp2,[]);
xticks([])
yticks([])
xlabel(' ')
text(4,8.25, 'two', 'horizontal', 'center')

%    text(4,8.25, 'two', 'horizontal', 'center')
end