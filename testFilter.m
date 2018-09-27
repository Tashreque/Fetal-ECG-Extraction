function [ finalSignal, lowPassSignal, beforeFinalFiltering ] = testFilter( sig )

sig = cdc(sig);
sig = normalize(sig);

currentSNR = 0;
for order = 10:4:100
    b = fir1(order, 0.20, 'low', kaiser(order+1, 0.5));
    filteredSignal = filter(b, 1, sig);
    filteredSignal = normalize(filteredSignal);
    
    noiseSignal = sig - filteredSignal;
    noiseSignal = normalize(noiseSignal);
    
    SNR = -20*log10(abs(noiseSignal)/abs(sig));
    if SNR > currentSNR;
        currentSNR = SNR;
        selectedFiltered = filteredSignal;
        currentOrder = order;
    end
end

currentSNR
currentOrder
lowPassSignal = selectedFiltered;

[b, a] = butter(4, 0.05, 'high');
baselineCutoff = filter(b, a, selectedFiltered);
baselineCutoff = normalize(baselineCutoff);

beforeFinalFiltering = baselineCutoff;

b1 = fir1(34, 0.08, 'low', kaiser(35, 0.5));
finalSignal = filter(b1, 1, baselineCutoff);

end