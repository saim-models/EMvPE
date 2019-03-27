function y = sigmoid(x,m,s)
%
% y = sigmoid(x,m,s) computation for the sigmoid-function.
%

y = 1 ./ (1+exp(-m*(x-s)));


