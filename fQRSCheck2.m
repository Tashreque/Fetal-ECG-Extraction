function [ result ] = fQRSCheck2( org, filtered )

resultant = org - filtered;
resultant = resultant/max(abs(resultant));
result = resultant;

end

