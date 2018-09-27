function [ sig ] = cdc( x1 )

sig = x1 - mean(x1);    % cancel DC conponents

end

