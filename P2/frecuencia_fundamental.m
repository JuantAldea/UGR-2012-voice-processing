function frecuencias_pitch_fragmentos = frecuencia_fundamental(ruta)
    [s n] = leemuestras(ruta, 0);

    tam_ventana = 240;
    solapamiento = tam_ventana/2;
    paso = tam_ventana - solapamiento;
    s = s(1:n - mod(n, paso));
    n = numel(s);

    subSignals = buffer(s, tam_ventana, solapamiento);
    subSignals = subSignals';

    c = num2cell(subSignals, 2);
    umbrales_clipping = cellfun(@clipping, c);
    umbrales_clipping = num2cell(umbrales_clipping, 2);
    c = cellfun(@center_clipping, c, umbrales_clipping, 'UniformOutput', false);
    [maximos_autocorrelacion, indices_maximos_autocorrelacion] = cellfun(@determinar_pitch, c, 'UniformOutput', false);
    clasificacion = cellfun(@fragmento_sordo_o_sonoro, c, maximos_autocorrelacion, 'UniformOutput', false);
    clasificacion = cell2mat(clasificacion);
    indices_maximos_autocorrelacion = cell2mat(indices_maximos_autocorrelacion);
    frecuencias_pitch_fragmentos = clasificacion .* indices_maximos_autocorrelacion;

    x = 1:numel(subSignals(6, :));
    subsC = cell2mat(c);
    
    %salida = frecuencias_pitch_fragmentos;
    % for i=1:n
    %     yo = subSignals(i, :);
    %     yc = subsC(i, :);
    %     plot(x, yo, x, yc);
    %     legend('original','clip');
    %     if clasificacion(i) == 1
    %         display('sonora')
    %     else
    %         display('sorda')
    %     end
    %     pause;
    % end
    
    %pitch = mode(histc(frecuencias_pitch_fragmentos(frecuencias_pitch_fragmentos > 0)));
