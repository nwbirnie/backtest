function [ ticks ] = SingleTicks(  )

M = dlmread('/home/inda/src/trades/yahoo.csv',',',1,2);

M(1,:)
ticks = M(:,3);

end

