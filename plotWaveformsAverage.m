function [  ] = plotWaveformsAverage( signal )

    prompt = 'Enter name of .mat file taken from fetal head:';
    fname = input(prompt, 's');
    
    load(strcat(fname, 'd'));
    
    fetalHead = val;
    fetalHead = (fetalHead + 1)/9.99984741211;
    
    [hR_value, hR_loc, fetalHead] = processHeadSignal(fetalHead);
    
    signal = (signal + 1)/9.99984741211; %database specific instruction
    
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
    hl = length(hR_value)
    
    Error = (abs(hl - fl)/hl)

    [tp, fp, fn, averageRR] = justifyRPeaks(fR_loc, hR_loc, fl);
    fR_loc;
    hR_loc;
    tp
    fp
    fn
    
    accuracy = (tp/(tp + fp + fn))*100
    
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
subplot(3,1,1)
title('ECG Signal with R points');
plot (x, finalSignal, x(R_loc) ,R_value, 'r^', x(S_loc), S_value, '*', x(Q_loc), Q_value, 'o');
legend('ECG','R','S','Q');

subplot(3,1,2)
title('FetalHead R peaks');
plot(x, fetalHead, x(hR_loc), hR_value, 'r^');
legend('R');

subplot(3,1,3)
title('Predicted Fetal R peaks');
plot(x, f, x(fR_loc), fR_value, 'r^');
legend('R');

end

