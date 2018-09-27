clc;

load('r01_edfm.mat');
sig = val;
sig = (sig + 1)/9.99984741211;
x = ((0:length(sig)-1)/1000);

% testFilter(sig);

fsig = fft(sig); %fast fourier transform
xf = linspace(0, 1000, length(sig));
plot(xf, abs(fsig));

