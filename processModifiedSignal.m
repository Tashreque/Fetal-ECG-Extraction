function [ fR_value, fR_loc ] = processModifiedSignal( signal )
    
    signal = normalize(signal);
    derived = applyDerivative(signal);

    squaredSignal = derived .^2;
    squaredSignal = normalize(squaredSignal);

    moving = movmean(squaredSignal, 120);
    moving = normalize(moving);

    [R_value, R_loc] = fetalRValues(moving, signal);
    fR_loc = R_loc;
    fR_value = R_value;

end

