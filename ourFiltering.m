function [ final ] = ourFiltering( sig )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

sig = sig - mean(sig);
sig = sig/max(abs(sig));

currentSNR = 0;
for order = 10:4:100
    b = fir1(order, 0.20, 'low', kaiser(order+1, 0.5));
    filteredSignal = filter(b, 1, sig);
    filteredSignal = filteredSignal/max(abs(filteredSignal));
    
    noiseSignal = sig - filteredSignal;
    noiseSignal = noiseSignal/max(abs(noiseSignal));
    
    SNR = abs(snr(filteredSignal, noiseSignal));
    if SNR > currentSNR;
        currentSNR = SNR;
        selectedFiltered = filteredSignal;
        currentOrder = order;
    end
end

temp = selectedFiltered;
[b, a] = butter(4, 0.05, 'high');
baselineCutoff = filter(b, a, selectedFiltered);
baselineCutoff = baselineCutoff/max(abs(baselineCutoff));

b1 = fir1(34, 0.08, 'low', kaiser(35, 0.5));
final = filter(b1, 1, baselineCutoff);
% final = baselineCutoff;

end

