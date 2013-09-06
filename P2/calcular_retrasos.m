function retraso = calcular_retrasos(frecuencias)
    retraso = zeros(size(frecuencias));
    for i = 2:numel(frecuencias)-1
        if (frecuencias (i-1) > 0 && frecuencias(i) > 0)
            retraso(i) = frecuencias(i-1) - mod(120 - retraso(i-1), frecuencias(i-1));
        end
    end
