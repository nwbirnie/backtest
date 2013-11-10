function [ model ] = SimpleModel( )
model = struct('timestep',@timestep,'initialise',@initialise,'complete',@complete);
end

function [isbuy, ammount] = timestep(tickerPrice)
global ticknum balance position emaLow emaHi sma macd signal macdHistory signalHistory;
ticknum = ticknum + 1;

if ticknum < 26
    sma = ((sma * (ticknum - 1) / (ticknum - 1)) + tickerPrice) / ticknum;
    isbuy = false;
    ammount = 0;
else
    if ticknum == 26
        emaLow = sma;
        emaHi = sma;
        macd = sma;
        signal = sma;
    end
    
    lowAlpha = (2/(12 + 1));
    emaLow = tickerPrice * lowAlpha + (1 - lowAlpha) * emaLow;

    hiAlpha = (2/(26 + 1));
    emaHi = tickerPrice * hiAlpha + (1 - hiAlpha) * emaHi;
    
    signalWasAbove = signal - macd > 0;
    macdAlpha = (2/(9 + 1));
    macd = emaHi - emaLow;
    signal = macd * macdAlpha + (1 - macdAlpha) * signal;
    signalIsAbove = signal - macd > 0;
        
    macdHistory.add(macd);
    signalHistory.add(signal);
    
    if ~signalWasAbove && signalIsAbove
        isbuy = true;
        ammount = floor(balance / tickerPrice);
        balance = balance - ammount * tickerPrice;
        position = position + ammount;
    elseif signalWasAbove && ~signalIsAbove
        isbuy = false;
        ammount = position;
        balance = balance + ammount * tickerPrice;
        position = position - ammount;
    else
        isbuy = false;
        ammount = 0;
    end
end
end

function [] = initialise(bal)
global balance position ticknum balance position emaLow emaHi sma macd signal macdHistory signalHistory;
balance = bal;
position = 0;
ticknum  = 1;
sma = 0;
macdHistory = java.util.LinkedList;
signalHistory = java.util.LinkedList;
end

function complete()
global macdHistory signalHistory;
macd = cell2mat(cell(macdHistory.toArray()));
signal = cell2mat(cell(signalHistory.toArray()));
figure
hold on
plot(macd,'color','b')
plot(signal,'color','r');
end