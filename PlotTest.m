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
    signal = (signal - 0)/65.535; %database specific instruction
    time = ((0:length(signal)-1)/1000)*1000;
    testFilter(signal);
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
    
        sig = (sig - 0)/65.535;
        sig2 = (sig2 - 0)/65.535;
        sig3 = (sig3 - 0)/65.535;
        
        separate = 'Plot seperately?y/n';
        seperateDecision = input(separate, 's');
        
        if yes == 1;
        sig4 = (sig4 - 0)/65.535;
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
    
        sig = (sig - 0)/65.535;
        sig2 = (sig2 - 0)/65.535;
        sig3 = (sig3 - 0)/65.535;
        avg3 = (sig + sig2 + sig3)/3;
        if yes == 1
        sig4 = (sig4 - 0)/65.535;
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

