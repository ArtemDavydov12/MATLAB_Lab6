classdef Equalizer < handle
    properties(Constant)
        freqArray{mustBeReal} = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000,16000];
    end
    properties(Access = public)
        gain = [1,1,1,1,1,1,1,1,1,1];
    end
    properties(GetAccess = public,SetAccess = protected)
        order double {mustBeInteger} = 64;
        fs double {mustBeReal} = 44100;
    end
    properties(Access = protected)
        bBank{mustBeReal}=[];
        initB{mustBeReal} = [];
    end
    methods
        function obj = Equalizer(order,fs)
            obj.order = order;
            obj.fs = fs;
            obj.CreateFilters();
        end
        function [signalOut,initB] = Filtering(obj,signal)
            b = sum(obj.gain.*obj.bBank', 1);
            [signalOut,initB] = filter(b, 1, signal, obj.initB);
        end
        function CreateFilters(obj)
        freqArrayNorm = obj.freqArray/(obj.fs/2);
        obj.bBank = zeros(length(obj.freqArray),obj.order+1);
         for m = 1:length(obj.freqArray)
            if m == 1
                mLow = [1, 1, 0, 0];
                freqLow = [0, freqArrayNorm(1), 2*freqArrayNorm(1), 1];
                obj.bBank(1, :) = fir2(obj.order, freqLow, mLow);
            elseif m == length(obj.freqArray)    
                   mHigh = [0, 0, 1, 1];
                   freqHigh = [0, freqArrayNorm(end)/2, freqArrayNorm(end), 1];
                   obj.bBank(length(obj.freqArray), :) = fir2(obj.order, freqHigh, mHigh);
            else 
                mBand = [0, 0, 1, 0, 0];
                freqBand = [0, freqArrayNorm(m-1), freqArrayNorm(m), freqArrayNorm(m+1), 1];
                obj.bBank(m, :) = fir2(obj.order, freqBand, mBand);
            end
         end
        end
        function [HdB,w] = GetFreqResponce(obj)
            b = sum(obj.gain.*obj.bBank',2);          
            [H,w] = freqz(b,1,obj.order);
            xdb = @(x)20*log10(x);
            HdB = xdb(abs(H));
            w = (w/pi)*(obj.fs/2);
        end
    end     
end   
        