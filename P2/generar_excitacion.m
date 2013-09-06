function excitacion = generar_excitacion(frecuencia, longitud, retraso)
    if frecuencia == 0
        excitacion = randn(longitud, 1);
    else
        excitacion = zeros(longitud, 1);
        excitacion(retraso + 1:frecuencia/2:longitud) = 1;
    end