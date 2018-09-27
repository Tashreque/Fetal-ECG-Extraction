function [ output ] = normalize( x1 )

output = x1/ max( abs(x1 )); %Normalize to [-1, 1]

end

