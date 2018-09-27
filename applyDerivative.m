function [ afterDerivative ] = applyDerivative( sig )

h = [-1 -2 0 2 1]/8;

derived = conv(sig, h);
derived = derived (2+[1: length(sig)]);
derived = normalize(derived);

afterDerivative = derived;

end

