function s = tren_pulsos(frecuencia, longitud)
    s = zeros(longitud, 1);
    s(1:frecuencia:longitud) = 1;
