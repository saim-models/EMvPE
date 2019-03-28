
function x = brownian_hopfield_euler(x_1, input, tau, sigma)
% x = brownian_euler(x_1, tau, sigma)
% x_1: x(t-1)
%[n m] = size(input)
% Brownian motion based on http://www.numericalexpert.com/blog/geometric_brownian_motion/
% and delta t = 1;
%
[n m] = size(x_1);

x = x_1 + 1/tau * (- x_1 -  input) + sigma * randn(n,m);

