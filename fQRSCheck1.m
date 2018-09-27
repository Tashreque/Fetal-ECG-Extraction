function [ fQRS, mQRSonly ] = fQRSCheck1( sig, left, right )

temp = sig;

left = left + 40;
right = right - 10;
j = 2;
sig(1:left(1)) = 0;
for i = 1:length(right)
    if j>length(right)
        sig(right(i):length(sig)) = 0;
    else
        sig(right(i):left(j)) = 0;
    end
    j = j + 1;
end

mQRS = sig;
noisyfQRS = temp - mQRS;

mQRSonly = mQRS;
fQRS = noisyfQRS;

end

