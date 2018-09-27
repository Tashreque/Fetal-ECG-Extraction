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
if exist(strcat(s, '.mat'), 'file')
    load(strcat(s, '.mat'));
    signal = val;
    
%     prompt = 'Enter name of .mat file taken from fetal head:';
%     fname = input(prompt, 's');
%     
%     load(strcat(fname, 'd'));
    
%     fetalHead = val;
%     fetalHead = (fetalHead + 1)/65.535;
    
%     [hR_value, hR_loc, fetalHead] = processHeadSignal(fetalHead);
    
    signal = (signal + 1)/65.535; %database specific instruction
    
    finalSignal = testFilter(signal);%filtered signal
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
    
    fl = length(fR_value)
%     hl = length(hR_value)
    
%     Error = (abs(hl - fl)/hl)

%     [tp, fp, fn, averageRR] = justifyRPeaks(fR_loc, hR_loc, fl);
%     fR_loc;
%     hR_loc;
%     tp
%     fp
%     fn
    
%     accuracy = (tp/(tp + fp + fn))*100
    
    x = ((0:length(signal)-1)/1000)*1000;
figure(1)
subplot(2,1,1)
plot(x, signal)
title('Original')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(2,1,2)
plot(x, finalSignal)
title('Filtered')
xlabel('time (ms)')
ylabel('Electrical Activity ')

figure(2)
subplot(2,1,1)
plot(x, finalSignal)
title('Original')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(2,1,2)
plot(x, maternal)
title('mQRS only')
xlabel('time (ms)')
ylabel('Electrical Activity ')

figure(3)
subplot(4,1,1)
plot(x, maternal)
title('mQRS only')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(4,1,2)
plot(x, fetal)
title('fQRS')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(4,1,3)
plot(x, f)
title('fQRS complexes only')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(4,1,4)
plot(x, fmoving)
title('squared')
xlabel('time (ms)')
ylabel('Electrical Activity ')


figure(4)
subplot(3,1,1)
plot(x, derived)
title('After Derivative')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(3,1,2)
plot(x, squaredSignal)
title('Squared')
xlabel('time (ms)')
ylabel('Electrical Activity ')

subplot(3,1,3)
plot(x, moving)
title('After moving window integration')
xlabel('time (ms)')
ylabel('Electrical Activity ')


figure(5)
subplot(2,1,1)
title('ECG Signal with R points');
plot (x, finalSignal, x(R_loc) ,R_value, 'r^', x(S_loc), S_value, '*', x(Q_loc), Q_value, 'o');
legend('ECG','R','S','Q');

subplot(2,1,2)
title('Predicted Fetal R peaks');
plot(x, f, x(fR_loc), fR_value, 'r^');
legend('R');
    
else s = 'File not Valid'
end
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
    
        sig = (sig + 1)/65.535;
        sig2 = (sig2 + 1)/65.535;
        sig3 = (sig3 + 1)/65.535;
        
        separate = 'Plot seperately?y/n';
        seperateDecision = input(separate, 's');
        
        if yes == 1;
        sig4 = (sig4 + 1)/65.535;
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
    
        sig = (sig + 1)/65.535;
        sig2 = (sig2 + 1)/65.535;
        sig3 = (sig3 + 1)/65.535;
        avg3 = (sig + sig2 + sig3)/3;
        if yes == 1
        sig4 = (sig4 + 1)/65.535;
        avg4 = (sig + sig2 + sig3 + sig4)/4;
        x = ((0:length(sig)-1)/1000)*1000;
        testFilter(avg4);
        else
        x = ((0:length(sig)-1)/1000)*1000;
        testFilter(avg3);
        end
        
else
    s = 'File not valid';
end

end

