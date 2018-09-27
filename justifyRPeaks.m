function [ truePositive, falsePositive, falseNegative ] = justifyRPeaks( f, h, fl )

tp = 0;
fn = 0;

j = 1;
for i = 1:length(h)
    if j < length(f)
        while f(j) < h(i)
             j = j + 1;
        end
    end

      if f(j) >= h(i) && f(j) < (h(i)+200)
          tp = tp + 1;
          if j <= length(f)
            j = j + 1;
          end
      end
      c = length(f(f>h(i) & f<(h(i)+200)));
      if c == 0
          fn = fn + 1;
      end
end

truePositive = tp;
falsePositive = fl - tp;
falseNegative = fn;

end

