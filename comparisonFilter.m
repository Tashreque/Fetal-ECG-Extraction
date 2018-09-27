function [ ] = comparisonFilter( sig )

temp = sig;

x = ((0:length(sig)-1)/1000)*1000;
sig = sig - mean(sig);
sig = sig/max(abs(sig));

b = fir1(10, 0.15, 'low', kaiser(11, 0.5));
low = filter(b, 1, sig);
low = low/max(abs(low));

b1 = fir1(50, 0.05, 'high', kaiser(51, 0.5));
high = filter(b1, 1, low);
high = high/max(abs(high));

[b2, a] = butter(4, 0.05, 'high');
final = filter(b2, a, high)
final = final/max(abs(final));

subplot(3,1,1)
plot(x, sig)

subplot(3,1,2)
plot(x, high)

subplot(3,1,3)
plot(x, final)
end

