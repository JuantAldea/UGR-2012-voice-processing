function x = autocorrelacion(s, indice)
    s1 = s(1:end - indice);
    s2 = s(1 + indice:end);
    x = sum(s1 .* s2);
    
