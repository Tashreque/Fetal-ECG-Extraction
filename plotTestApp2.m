clc;
prompt = 'Enter name of .mat file without extension:';
name = input(prompt, 's');
ifall = 'Generate all signals?y/n/average';
decision = input(ifall, 's');
if decision == 'y'
    generateAllSignals(name);
else if decision == 'average'
    generateAverage(name);
else generateMySignal(name);
end
end

function [ ] = generateMySignal( s )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
plotRequiredWaveforms(s);
end


function [ ] = generateAllSignals( s )  
yes = 0;
sub = 0;
f = strtok(s, '-');
if exist(strcat(f, '.mat'), 'file')
    load(strcat(f, '.mat'));
    sig = val;
    load(strcat(f, '-2', '.mat'));
    sig2 = val;
    load(strcat(f, '-3', '.mat'));
    sig3 = val;
    
    if exist(strcat(f, '-4', '.mat'), 'file')
        load(strcat(f, '-4', '.mat'));
        sig4 = val;
        yes = 1;
    end
    
        sig = (sig + 1)/9.99984741211;
        sig2 = (sig2 + 1)/9.99984741211;
        sig3 = (sig3 + 1)/9.99984741211;
        
        separate = 'Plot seperately?y/n';
        seperateDecision = input(separate, 's');
        
        if yes == 1;
        sig4 = (sig4 + 1)/9.99984741211;
        x = ((0:length(sig)-1)/1000)*1000;
        if seperateDecision == 'y';
            subplot(2,2,1)
            plot(x, sig)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_1(uV)')
            subplot(2,2,2)
            plot(x, sig2)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_2(uV)')
            subplot(2,2,3)
            plot(x, sig3)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_3(uV)')
            subplot(2,2,4)
            plot(x, sig4)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_4(uV)')
        else
            
        plot(x, sig, x, sig2, x, sig3, x, sig4)
        xlabel('time (ms)')
        ylabel('Electrical activity')
        legend('Abdomen_1(uV)', 'Abdomen_2(uV)', 'Abdomen_3(uV)', 'Abdomen_4(uV)')
        end
        
        else
        x = ((0:length(sig)-1)/1000)*1000;
        if seperateDecision == 'y'
            subplot(2,2,1)
            plot(x, sig)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_1(uV)')
            subplot(2,2,2)
            plot(x, sig2)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_2(uV)')
            subplot(2,2,3)
            plot(x, sig3)
            xlabel('time(ms)')
            ylabel('Electrical activity')
            legend('Abdomen_3(uV)')
        else
        plot(x, sig, x, sig2, x, sig3)
        xlabel('time (ms)')
        ylabel('Electrical Activity ')
        legend('Abdomen_1(uV)', 'Abdomen_2(uV)', 'Abdomen_3(uV)')
        end
        end
else
    s = 'File not valid'
end

end


function [ ] = generateAverage( s )

yes = 0;
f = strtok(s, '-');
if exist(strcat(f, '.mat'), 'file')
    load(strcat(f, '.mat'));
    sig = val;
    load(strcat(f, '-2', '.mat'));
    sig2 = val;
    load(strcat(f, '-3', '.mat'));
    sig3 = val;
    
    if exist(strcat(f, '-4', '.mat'), 'file')
        load(strcat(f, '-4', '.mat'));
        sig4 = val;
        yes = 1;
    end
    
        sig = (sig + 1)/9.99984741211;
        sig2 = (sig2 + 1)/9.99984741211;
        sig3 = (sig3 + 1)/9.99984741211;
        avg3 = (sig + sig2 + sig3)/3;
        if yes == 1
        sig4 = (sig4 + 1)/9.99984741211;
        avg4 = (sig + sig2 + sig3 + sig4)/4;
        x = ((0:length(sig)-1)/1000)*1000;
%         testFilter(avg4);
        plotWaveformsAverage(avg4);
        else
        x = ((0:length(sig)-1)/1000)*1000;
%         testFilter(avg3);
        plotWaveformsAverage(avg3);
        end
        
else
    s = 'File not valid';
end

end

function [  ] = plotRequiredWaveforms( s )

if exist(strcat(s, '.mat'), 'file')
    load(strcat(s, '.mat'));
    signal = val;
    
    prompt = 'Enter name of .mat file taken from fetal head:';
    fname = input(prompt, 's');
    
    load(strcat(fname, 'd'));
    
    fetalHead = val;
    fetalHead = (fetalHead + 1)/9.99984741211;
    
    [hR_value, hR_loc, fetalHead] = processHeadSignal(fetalHead);
    
    signal = (signal + 1)/9.99984741211; %database specific instruction
    
    [finalSignal, lowPassSignal, beforeFinalFiltering] = testFilter(signal);%filtered signal
    finalSignal = normalize(finalSignal);
    
    derived = applyDerivative(finalSignal);

    squaredSignal = derived .^4;
    squaredSignal = normalize(squaredSignal);

    moving = movmean(squaredSignal, 120);
    moving = normalize(moving);
    
    [Q_value,Q_loc,  R_value,R_loc,  S_value,S_loc, left,right] = getQRS(moving, finalSignal);

    [fetal, maternal] = fQRSCheck1(finalSignal, left, right);

    f = getFetalSignal(fetal);
    f = normalize(f);
    
    fderived = applyDerivative(f);
    
    fSquared = fderived .^2;
    fSquared = normalize(fSquared);
    
    fmoving = movmean(fSquared, 120);
    fmoving = normalize(fmoving);
    
    [fR_value, fR_loc] = fetalRValues(fmoving, f);
    
    fl = length(fR_value);

    [tp, fp, fn] = justifyRPeaks(fR_loc, hR_loc, fl);
    
    [averageRR, intervals] = getRRInterval(fR_loc);
    [newRR, modifiedSignal, mfR_value, mfR_loc] = modifySignal(f, averageRR, intervals, fR_loc, R_loc);
    
    mfl = length(mfR_value);
    [tpm, fpm, fnm] = justifyRPeaks(mfR_loc, hR_loc, mfl);
  
    averageRR
    newRR
    tp
    fp
    fn
    tpm
    fpm
    fnm
    
    accuracy = (tp/(tp + fp + fn))*100
    newAccuracy = (tpm/(tpm + fpm + fnm))*100
    
    x = ((0:length(signal)-1)/1000)*1000;
    
    set(0,'defaultlinelinewidth',1);
figure(1)
subplot(2,1,1)
plot(x, signal)
title('Original')
xlabel('time (ms)')
ylabel('Electrical Activity(uV)')

% subplot(2,1,1)
% plot(x, lowPassSignal)
% title('After low pass filtering')
% xlabel('time (ms)')
% ylabel('Electrical Activity(mV)')
% 
% subplot(2,1,1)
% plot(x, beforeFinalFiltering)
% title('Baseline wander cut-off')
% xlabel('time (ms)')
% ylabel('Electrical Activity(mV)')

subplot(2,1,2)
plot(x, finalSignal)
title('Preprocessed')
xlabel('time (ms)')
ylabel('Electrical Activity')

figure(2)
subplot(2,1,1)
plot(x, finalSignal)
title('Filtered')
xlabel('time (ms)')
ylabel('Electrical Activity')

subplot(2,1,2)
plot(x, maternal)
title('mQRS only')
xlabel('time (ms)')
ylabel('Electrical Activity')

figure(3)
subplot(4,1,1)
plot(x, maternal)
title('mQRS only')
xlabel('time (ms)')
ylabel('EA')

subplot(4,1,2)
plot(x, fetal)
title('Extracted Fetal ECG')
xlabel('time (ms)')
ylabel('EA')

subplot(4,1,3)
plot(x, f)
title('Processed Fetal ECG')
xlabel('time (ms)')
ylabel('EA')

subplot(4,1,4)
plot(x, fetalHead)
title('Reference Scalp FECG')
xlabel('time (ms)')
ylabel('EA')


figure(4)
subplot(3,1,1)
plot(x, derived)
title('After Derivative')
xlabel('time (ms)')
ylabel('Electrical Activity')

subplot(3,1,2)
plot(x, squaredSignal)
title('Derived^4')
xlabel('time (ms)')
ylabel('Electrical Activity')

subplot(3,1,3)
plot(x, moving)
title('After moving window integration')
xlabel('time (ms)')
ylabel('Electrical Activity')


figure(5)
subplot(2,1,1)
plot (x, finalSignal, x(R_loc) ,R_value, 'r^', x(S_loc), S_value, '*', x(Q_loc), Q_value, 'o');
legend('ECG','R','S','Q');
title('ECG Signal with R points');
xlabel('Time(ms)');
ylabel('Electrical Activity');

% subplot(4,1,2)
% plot(x, fetalHead, x(hR_loc), hR_value, 'r^');
% legend('R');
% title('Reference Scalp ECG');
% xlabel('Time(ms)');
% ylabel('EA');
% 
% subplot(4,1,3)
% plot(x, f, x(fR_loc), fR_value, 'r^');
% legend('R peaks', 'R');
% title('Predicted Fetal R peaks');
% xlabel('Time(ms)');
% ylabel('EA');
% 
% subplot(4,1,4)
% plot(x, modifiedSignal, x(mfR_loc), mfR_value, 'r^');
% legend('R peaks', 'R');
% title('Modified');
% xlabel('Time(ms)');
% ylabel('EA');

figure(6)
subplot(2,1,1)
plot(x, signal)
title('MAECG')
xlabel('time (ms)')
ylabel('Electrical Activity(uV)')

subplot(2,1,2)
plot(x, modifiedSignal);
title('Modified FECG');
xlabel('Time(ms)');
ylabel('Electrical Activity');

    
else s = 'File not Valid'
end

end

