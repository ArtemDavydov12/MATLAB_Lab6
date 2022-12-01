function [signalOut, initB] = filteringBanks(signal, f_bank, gain, typeOfFilter, initB)
f_bank_new = sum(gain .* f_bank);

switch typeOfFilter
    case 'filter'
        [signalOut, initB] = filter(f_bank_new, 1, signal, initB);
    case 'fftfilter'
         signalOut = fftfilt(f_bank_new, signal);
    case 'convFilter'
        signalOut = convFilter(f_bank_new, signal);
         
end
end
function signalOut = convFilter(f_bank_new, signal)
A = size(signal);
if A(1) > A(2)
    for i = 1 : A(2)
        signalOut(:,i) = conv(signal(:, i), f_bank_new);
    end
else
    for i = 1 : A(1)
        signalOut(i, :) = conv(signal(i, :), f_bank_new);
    end
end
end