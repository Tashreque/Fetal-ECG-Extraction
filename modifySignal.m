function [ newRR, final, fR_value, finalR_loc ] = modifySignal( signal, RR, intervals, fR_loc, R_loc )

for i = 1:length(intervals)
    deviations(i) = abs(RR - intervals(i));
end

intervals = intervals(deviations < 200);

total = 0;
for k = 1:length(intervals)
    total = total + intervals(k);
end

newRR = total/length(intervals);
intRR = int32(newRR);

%Remove false positives
p = 1;
flag = 0;
length(fR_loc)
while (p <= length(fR_loc))
    q = p + 1;
    r = q + 1;
   
    current = fR_loc(p);
    if q <= length(fR_loc) && r <= length(fR_loc)
        while (fR_loc(q)-current)<newRR && (newRR-(fR_loc(q)-current))>(intRR/5)
            if abs(newRR-(fR_loc(r)-fR_loc(q)))<(intRR/5)
               signal((fR_loc(p)-50):(fR_loc(p)+50)) = 0;
               fR_loc(p) = 0;
               q = q + 1;
               r = r + 1;
               flag = 2;
            else
               signal((fR_loc(q)-50):(fR_loc(q)+50)) = 0;
               fR_loc(q) = 0;
               r = r + 1;
               q = q + 1;
               flag = 1;
            end
        end
    end
    if flag == 1
        p = q;
        flag = 0;
    elseif flag == 2
        p = r;
        flag = 0;
    else
        p = p + 1;
    end
    
end
fR_loc = fR_loc(fR_loc ~= 0);
length(fR_loc)

%Reduce false negatives
temp = fR_loc;
p = 1;
while (p <= length(fR_loc))
    q = p + 1;
    current = fR_loc(p);
    if q <= length(fR_loc)
        if (fR_loc(q)-current)>newRR && abs(newRR-(fR_loc(q)-current))>=200
            ql = R_loc(R_loc>current & R_loc<=(current+newRR+100));
            if length(ql)==1
                a = current+intRR-100;
                b = current+intRR+100;
%                 if b <= length(signal) && a > 0    
                signal(a:b) = (signal((current-100):(current+100))+signal((fR_loc(q)-100):(fR_loc(q)+100)))/2;
                temp = sort([temp, (current+intRR)]);
%                 end
            end
        end
    end
    p = p + 1;
end
fR_loc = temp;
length(fR_loc)

temp1 = fR_loc;
%Reduce false negatives at the start of the signal
if (fR_loc(1)-0)>newRR && abs(newRR-(fR_loc(1)-0))>=200
        ql = R_loc(R_loc>0 & R_loc<=fR_loc(1));
        now = fR_loc(1);
        for i = 1:length(ql)
            signal((now-intRR-100):(now-intRR+100)) = signal((fR_loc(1)-100):(fR_loc(1)+100));
            temp1 = sort([temp1, (now-intRR)]);
            now = now - intRR;
        end
end
fR_loc = temp1;
length(fR_loc)

%Remove high frequency noise to smoothen the signal further
b = fir1(34, 0.02, 'low', kaiser(35, 0.5));
for k = 1:length(fR_loc)
    if k<length(fR_loc)
       la = int32(fR_loc(k))+50;
       lb = int32(fR_loc(k+1))-50;
       if lb <= length(signal)
          signal(la:lb) = filter(b, 1, signal(la:lb));
       end
    end
end
signal(1:(fR_loc(1)-50)) = filter(b, 1, signal(1:(fR_loc(1)-50)));
signal((fR_loc(length(fR_loc))+50):length(signal)) = filter(b, 1, signal((fR_loc(length(fR_loc))+50):length(signal)));


[val, fR_loc] = processModifiedSignal(signal);
fR_value = val;
finalR_loc = fR_loc;

final = signal;

end

