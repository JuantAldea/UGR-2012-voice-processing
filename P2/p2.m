function vozbuena = p2(ruta)

%ruta = './8kfil/euge0013.8f';
muestras=leemuestras(ruta, 0);
numero_segmentos = floor(numel(muestras)/120);
muestras = muestras(1:numero_segmentos * 120);
segmentos = buffer(muestras, 120);

%%
%filtros LPC
filtros = lpc(segmentos, 10);
filtros(isnan(filtros)) = 0;
filtros = -filtros(:, 2:end);
filtros = fliplr(filtros);

%%
%Calculo de la excitacion
segmentos_130 = buffer(muestras, 130, 10);
segmentos_130_cell = num2cell(segmentos_130, 1);
filtros_cell = num2cell(filtros, 2); 
excitacion_cell = cellfun(@calcular_excitacion, filtros_cell', segmentos_130_cell, 'UniformOutput', false);

%%
% "prueba" de reconstruccion
excitacion = cell2mat(excitacion_cell);
excitacion_vector = excitacion(:);
reconstruccion = prueba_reconstruccion(filtros, excitacion_vector, muestras);
error = sum(abs(reconstruccion(:) - muestras));

%%
%respuestas del filtro a la excitacion
excitacion_cell = num2cell(excitacion, 1);
%excitacion_cell = num2cell(zeros(size(excitacion)), 1);
respuesta_excitacion_cell = cellfun(@respuesta_excitacion, filtros_cell', excitacion_cell, 'UniformOutput', false);

%respuestas del filtro al impulso unitario
impulso_unitario = zeros(120, numero_segmentos);
impulso_unitario(1, :) = ones(numero_segmentos, 1);
impulso_unitario_cell = num2cell(impulso_unitario, 1);
respuesta_impulso_unitario_cell = cellfun(@respuesta_excitacion, filtros_cell', impulso_unitario_cell, 'UniformOutput', false);

%%
%segunda parte
pitchs = frecuencia_fundamental(ruta);
indices_segmentos_sonoros = find(pitchs);
indices_segmentos_sordos = find(pitchs==0);

%%
%energia de las excitaciones
energia_excitacion_cell = cellfun(@energia, excitacion_cell)';
energia_excitacion_cell = num2cell(energia_excitacion_cell);
%energia_excitacion = energia(excitacion);

%excitaciones sinteticas
pitchs_cells = num2cell(pitchs);
longitud = num2cell(ones(size(pitchs)) * 120);
%retrasos = num2cell(zeros(size(pitchs)));
retrasos = calcular_retrasos(pitchs);
retrasos_cell = num2cell(retrasos);
excitaciones_sinteticas_cell = cellfun(@generar_excitacion, pitchs_cells, longitud, retrasos_cell, 'UniformOutput', false);

%calculo de las ganancias
ganancias_cell = cellfun(@ganancia, energia_excitacion_cell, excitaciones_sinteticas_cell);
ganancias_cell = num2cell(ganancias_cell);

%excitacion y ganancia
excitaciones_sinteticas_normalizadas_cell = cellfun(@normalizar_senial, excitaciones_sinteticas_cell, ganancias_cell, 'UniformOutput', false);
%voz sintetica
respuesta_excitacion_sintetica_normalizada = cellfun(@respuesta_excitacion, filtros_cell', excitaciones_sinteticas_normalizadas_cell', 'UniformOutput', false);
voz = cell2mat(respuesta_excitacion_sintetica_normalizada);

%%
historial = zeros(1, 10);
h = zeros(size(segmentos));
for i = 1:numero_segmentos
    filtro = filtros(i, :);
    excitacion_sintetica_normalizada = excitaciones_sinteticas_normalizadas_cell{i, 1};
    respuesta_historial = respuesta_excitacion_historia(filtro, excitacion_sintetica_normalizada, historial);
    h(:, i) = respuesta_historial;
    historial = respuesta_historial(end-10+1 : end)';
    %historial = zeros(1, 10);
end

%%
if (false)
    for n = 1:numero_segmentos
        [fft_segmento, f] = calcular_fft(segmentos(:, n));
        [fft_excitacion, ~] = calcular_fft(excitacion_cell{1, n});
        [fft_respuesta_excitacion, ~] = calcular_fft(respuesta_excitacion_cell{1, n});
        [fft_respuesta_impulso, ~] = calcular_fft(respuesta_impulso_unitario_cell{1, n});
        [fft_excitacion_sintetica_normalizada, ~] = calcular_fft(excitaciones_sinteticas_normalizadas_cell{n, 1});
        [fft_resouesta_excitacion_sintetica_normalizada, ~] = calcular_fft(respuesta_excitacion_sintetica_normalizada{1, n});
        subplot(3,4,1),
            plot(segmentos(:, n));
            title('Segmento');

        subplot(3,4,2), 
            plot(excitacion(:, n));
            title('Excitacion');

        subplot(3,4,3),
            plot(reconstruccion(:, n));
            title('Segmento Recompuesto');

        subplot(3,4,4),
            plot(f, fft_segmento);
            title('FFT segmento');

        subplot(3,4,5),
            plot(f, fft_excitacion);
            title('FFT excitacion');

        subplot(3,4,6), 
            plot(f, fft_respuesta_excitacion);
            title('FFT respuesta Excitacion');

        subplot(3,4,7),
            plot(f, fft_respuesta_impulso);
            title('FFT respuesta Impulso');

        subplot(3,4,8),
            stem(excitaciones_sinteticas_cell{n, 1});
            title('Excitacion sintetica');
        subplot(3,4,9),
            plot(f, fft_excitacion_sintetica_normalizada);
            title('FFT excitacion sintetica');

        subplot(3,4,10),
            stem(excitaciones_sinteticas_cell{n, 1}*ganancias_cell{n, 1});
            title('Excitacion sintetica con amplitud');
        subplot(3,4,11),
            plot(respuesta_excitacion_sintetica_normalizada{1, n});
            title('Excitacion sintetica con amplitud');
        subplot(3,4,12),
            plot(f, fft_resouesta_excitacion_sintetica_normalizada);
            title('FFT excitacion sintetica con amplitud');
        pause;
    end
end

figure
ax = [];
ax(1) = subplot(3,1,1);
plot(1:numel(muestras), muestras);
ax(2) = subplot(3,1,3);
plot(1:numel(voz), voz(:));
ax(3) = subplot(3,1,2);
plot(1:numel(h), h(:));
linkaxes([ax(3), ax(2), ax(1)], 'xy');

%figure;
%hold on;
indice = 20;
a = 1:numel(h(:, indice));
%plot(a, segmentos(:, indice),'r');
%plot(a, h(:, indice), 'g');
%plot(a, voz(:, indice), 'b');

e1 = energia(segmentos(:, indice))
e2 = energia(h(:, indice))
e3 = energia(voz(:, indice))

vozbuena = h(:);

