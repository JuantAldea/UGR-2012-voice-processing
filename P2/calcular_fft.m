function [transformada, f] = calcular_fft(s)
    L = numel(s);
    Fs = 8000;
    NFFT = 2^10;%nextpow2(L); % Next power of 2 from length of y
    f = Fs/2 * linspace(0, 1, NFFT);
    transformada = fft(s, NFFT)/L;
    transformada = 2*abs(transformada(1:NFFT));