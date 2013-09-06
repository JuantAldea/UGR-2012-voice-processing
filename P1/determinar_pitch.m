function [maximo indice_maximo] = determinar_pitch(s)
    valores_autocorrelacion = zeros(1, 120-20 + 1);
    
    for i = 20:120
        valores_autocorrelacion(i-19) = autocorrelacion(s, i);
    end
    
    [picos indices_picos] = findpeaks(valores_autocorrelacion);
    
    if numel(picos) == 0
        maximo = -1;
        indice_maximo = -1;
    else
        [maximo indice_pico_maximo] = max(picos);
        indice_maximo = indices_picos(indice_pico_maximo) + 19;
    end
    