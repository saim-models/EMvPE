function y = sigmoid(x,m,s)
%
% y = sigmoid(x,m,s) computation of the sigmoid-function.
%

y = 1 ./ (1+exp(-m*(x-s)));


