classdef Equalizer < handle
    properties(Constant  =  true)
         freqArray (10, 1) {double} = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000];
    end
    properties (Access = public)
        gain (10, 1) {double} = ones;
    end
    properties (GetAccess = public, SetAccess = protected)
        order (1, 1) {double} = 64;
        fs (1, 1) {double} = 44100;
    end
    properties(Access = protected)
        bBank {double};
        initB {double} = [ ];
    end
    methods
        function obj = Equalizer(order, fs)
            obj.order = order;
            obj.fs = fs;
            obj.bBank = zeros(length(freqArray), order + 1);
        end
        function obj = Filtering(gain, bBank, signal)
            obj.bBank_new = sum(gain .* bBank);
            obj.signalOut = filter(bBank_new, 1, signal);
        end
    end
end

