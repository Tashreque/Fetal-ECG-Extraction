function [ r_val, r_loc, final ] = processHeadSignal( sig )

    [finalSignal, lowPassSignal, beforeFinalFilter] = testFilter(sig);%filtered signal
    finalSignal = normalize(finalSignal);
    
    derived = applyDerivative(finalSignal);

    squaredSignal = derived .^2;
    squaredSignal = normalize(squaredSignal);

    moving = movmean(squaredSignal, 120);
    moving = normalize(moving);

    [fR_value, fR_loc] = fetalRValues(moving, finalSignal);
    
    final = finalSignal;
    r_val = fR_value;
    r_loc = fR_loc;

end

