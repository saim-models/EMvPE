function x = inverse_sigmoid(y,m,s)
%
% x = inverse_sigmoid(y,m,s) computation for the in inverse sigmoid-function.
%

x = -(1 / m) *log(1./y-1)+s;