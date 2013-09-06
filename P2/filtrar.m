function excitacion = filtrar(filtro, segmento)
    p = numel(filtro);
    s_n_k = buffer([0; segmento], p, p-1);
    s_n_k = s_n_k(:, 1:end - 1);
    replicas = numel(segmento);
    idx = accumarray((cumsum(replicas)+1)',ones(size(replicas))');
    filtro_replicado = filtro(cumsum(idx(1:end-1))+1, :);
    excitacion = segmento + sum(filtro_replicado' .* s_n_k)';