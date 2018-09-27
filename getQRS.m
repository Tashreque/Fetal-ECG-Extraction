function [ qval,qloc,  rval,rloc,  sval,sloc, l,r ] = getQRS( sig, filtered )

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
 
    [Q_value(i) Q_loc(i)] = min( filtered(left(i):R_loc(i)) );
    Q_loc(i) = Q_loc(i)-1+left(i); % add offset
 
    [S_value(i) S_loc(i)] = min( filtered(left(i):right(i)) );
    S_loc(i) = S_loc(i)-1+left(i); % add offset

end

Q_loc=Q_loc(find(Q_loc~=0));
R_loc=R_loc(find(R_loc~=0));
S_loc=S_loc(find(S_loc~=0));

l = left;
r = right;

qval = Q_value;
qloc = Q_loc;

rval = R_value;
rloc = R_loc;

sval = S_value;
sloc = S_loc;
