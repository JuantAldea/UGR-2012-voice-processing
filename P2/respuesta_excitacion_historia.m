function h = respuesta_excitacion_historia(filtro, excitacion, historial)
    p = numel(filtro);
    h = [historial, excitacion'];
    
    for i = p + 1 : numel(h)
        h(i) = h(i) + sum(filtro .* h(i-p : i-1));
    end
    
    h = h(p + 1:end)';