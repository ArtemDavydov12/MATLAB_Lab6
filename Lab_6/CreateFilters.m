function bBank = CreateFilters(freqArray, order, fS)
freqArrayNorm = freqArray/(fS/2);
mLow = [1, 1, 0, 0];
mBand = [0, 0, 1, 0, 0];
mHigh = [0, 0, 1, 1];
bBank = zeros(length(freqArray), order + 1);
for k = 1:length(freqArray)
    if k == 1
        freqLow = [0, freqArrayNorm(k), 2*freqArrayNorm(k), 1];
        bBank(k,:) = fir2(order, freqLow, mLow);
    elseif k == length(freqArray)
        freqHigh = [0, freqArrayNorm(k)/2, freqArrayNorm(k), 1];
        bBank(k,:) = fir2(order, freqHigh, mHigh);
    else
        freqBand = [0, freqArrayNorm(k-1),freqArrayNorm(k), freqArrayNorm(k+1), 1];
        bBank(k,:) = fir2(order,freqBand, mBand);
    end
end
