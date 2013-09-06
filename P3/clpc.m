function coef_clpc_cell = clpc(s)
    segmentos = buffer(s, 256, 128, 'nodelay');
    coeficientes_lpc = lpc(segmentos, 10);
    coeficientes_lpc = coeficientes_lpc(:, 2:end);
    [n, ~] = size(coeficientes_lpc);
    coeficientes_lpc = [coeficientes_lpc, zeros(n, 2)];
    cell_coeficientes = num2cell(coeficientes_lpc, 2);
    coef_clpc_cell = cellfun(@cepstrum, cell_coeficientes, 'UniformOutput', false);