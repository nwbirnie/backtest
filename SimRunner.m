function [ roi ] = SimRunner( ticks, model )

initialBalance = 1000000;
balance = initialBalance;
position = 0;
trades = 0;
model.initialise(balance)
balanceHistory= java.util.LinkedList;

for i=1:numel(ticks)
    currentPrice = ticks(i);
    [isbuy, ammount] = model.timestep(currentPrice);
    if ammount > 0
        if isbuy
            if ammount * currentPrice > balance
                error('invalid buy %d %d %d %d', ammount, currentPrice, balance, ammount * currentPrice - balance);
            else
                position = position + ammount;
                balance = balance - ammount * currentPrice;
            end
        else
            if position < ammount
                error('invalid sell %d %d',ammount, position);
            else
                position = position - ammount;
                balance = balance + ammount * currentPrice;
            end
        end
        trades = trades + 1;
    end
    balanceHistory.add(balance + position * currentPrice);
end

figure
plot(cell2mat(cell(balanceHistory.toArray())));
figure
plot(ticks)
trades

model.complete();

roi = balance - initialBalance + position * currentPrice;
end
