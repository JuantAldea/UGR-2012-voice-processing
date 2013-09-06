 archivos = dir('recvoz/');
 muestras = cell(numel(archivos) - 2, 1);
 
 for i = 3:numel(archivos) ;
     muestras{i - 2} = leemuestras(strcat('recvoz/', archivos(i).name), 0);
     %soundsc(muestras{i-2});
 end
 
 representantes = cell(numel(muestras)/3, 1);
 indices_representantes = -ones(numel(muestras)/3, 1);
 for i = 1:3:numel(muestras)
     longitudes = [numel(muestras{i}), numel(muestras{i+1}), numel(muestras{i+2})];
     indice = find(longitudes == median(longitudes));
     indice = indice(1);
     indices_representantes(1+int32(i/3)) = indice; 
     representantes{1+int32(i/3)} = muestras{i + indice - 1};
 end
 
 %a = representantes{1};
 %representantes = {};
 %representantes{1} = a;
 
 coeficientes_cepstrales_representantes_cell = cellfun(@clpc, representantes, 'UniformOutput', false);
 coeficientes_cepstrales_muestras_cell = cellfun(@clpc, muestras, 'UniformOutput', false);
 indice_minimos = -ones(size(muestras));
 for i = 1:numel(coeficientes_cepstrales_muestras_cell)
     minimo = Inf;
     for j = 1:numel(coeficientes_cepstrales_representantes_cell)
         distancia = dtw(coeficientes_cepstrales_muestras_cell{i}, coeficientes_cepstrales_representantes_cell{j});
         [minimo, indice] = min([minimo distancia]);
         if indice == 2
             indice_minimos(i) = j;
         end
     end
 end
 