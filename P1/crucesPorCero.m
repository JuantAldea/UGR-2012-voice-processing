function cruces = crucesPorCero(s)
    positivos = s >= 0;
    negativos = s < 0;
    signos = positivos - negativos;

    signos1 = signos(1:end-1);
    signos2 = signos(2:end);
    cruces = sum((signos1 + signos2) == 0);

