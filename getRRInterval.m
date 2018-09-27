function [ averageRR, intervals ] = getRRInterval( f )

RRintervals(length(f) - 1) = 0;
for k = 2:length(f)
    RRintervals(k-1) = f(k) - f(k-1);
end

intervals = RRintervals;

totalRR = 0;
for m = 1:length(RRintervals)
    totalRR = totalRR + RRintervals(m); 
end

averageRR = totalRR/length(RRintervals);

end

