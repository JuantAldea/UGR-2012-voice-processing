leeleefunction c = cepstrum(filtro)
    filtro = filtro(:);
    c = zeros(size(filtro));
    c(1) = -xfiltro(end);
    pesos = zeros(size(c));
    filtro = fliplr(filtro);
    for i = 1:numel(filtro)
        pesos(1:i-1) = (1/i : 1/i : 1 - 1/i)';
        c(i) = -filtro(1) - sum(pesos .* c .* filtro);
    end
    c = c';