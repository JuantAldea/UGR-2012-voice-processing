function [X, n] = leemuestras(fichero, nmues)
    f = fopen(fichero,'r');
    if (nmues > 0)
    [X, n] = fread(f, nmues, 'int16');
    else
    [X, n] = fread(f, Inf, 'int16');
    end
    fclose(f);