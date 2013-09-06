function excitacion = calcular_excitacion(filtro, segmento_130)
    p = numel(filtro);
    s_n_k = buffer(segmento_130, p, p-1, 'nodelay');
    s_n_k = s_n_k(:, 1:end - 1);
    replicas = numel(segmento_130) - p;
    idx = accumarray((cumsum(replicas)+1)',ones(size(replicas))');
    filtro_replicado = filtro(cumsum(idx(1:end-1))+1, :);
    excitacion = segmento_130(p + 1: end) - sum(filtro_replicado' .* s_n_k)';