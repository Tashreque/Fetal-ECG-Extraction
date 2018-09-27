% clc;
% load('r07_edfm');
% 
% signal = val;
% signal = (signal + 1)/9.99984741211; %database specific instruction
% x = ((0:length(signal)-1)/1000)*1000;
% 
% signal = ourFiltering(signal);
% 
% dwtmode('per', 'nodisplay');
% wname = 'sym6';
% level = 5;
% [c, l] = wavedec(signal, level, wname);
% 
% %plotDetCoefHelper(original, c, l);
% fd = wden(signal, 'rigrsure', 's', 'mln', level, wname);
% 
% subplot(2,1,1)
% plot(x, signal)
% grid on;
% 
% subplot(2,1,2)
% plot(x, fd)
% grid on;
set(0,'defaultlinelinewidth',2);
b = butter(4, 0.05, 'high');
freqz(b, 1)