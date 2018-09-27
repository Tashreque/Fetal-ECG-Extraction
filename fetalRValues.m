function [ rval, rloc ] = fetalRValues( sig, filtered )

max_h = max(sig);
thresh = mean(sig);
poss_reg =(sig > (thresh*max_h))';

left = find(diff([0 poss_reg'])==1);
right = find(diff([poss_reg' 0])==-1);

if (left(1)-(6+16)) > 0
    left=left-(6+16);  % cancle delay because of LP and HP
    right=right-(6+16);% cancle delay because of LP and HP
end
 
for i=1:length(left)
    [R_value(i) R_loc(i)] = max( filtered(left(i):right(i)) );
    R_loc(i) = R_loc(i)-1+left(i); % add offset
 
end

R_loc=R_loc(find(R_loc~=0));

rval = R_value;
rloc = R_loc;


end

