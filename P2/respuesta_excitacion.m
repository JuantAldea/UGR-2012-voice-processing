function h = respuesta_excitacion(filtro, excitacion)
    p = numel(filtro);
    %h = [zeros(size(filtro)), zeros(size(excitacion))'];
    h = [zeros(size(filtro)), excitacion'];
    
    for i = p + 1 : numel(h)
        h(i) = h(i) + sum(filtro .* h(i-p : i-1));
    end
    
    h = h(p + 1:end)';