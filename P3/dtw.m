function distancia = dtw(v1, v2)
    [n, ~] = size(v1);
    [m, ~] = size(v2);
    v1 = cell2mat(v1);
    v2 = cell2mat(v2);

    matriz_DTW = zeros(n + 1, m + 1);
    matriz_DTW(:, 2:end) = Inf;
    matriz_DTW(2:end, :) = Inf;
    matriz_DTW(1) = 0;

    for i = 2:n+1
        for j = 2:m+1
            distancia = norm(v1(i-1, :) - v2(j-1, :)); 
            minimo = min([matriz_DTW(i - 1, j), matriz_DTW(i, j - 1), matriz_DTW(i - 1, j - 1) + distancia]);
            matriz_DTW(i, j) = distancia + minimo;
        end
    end

    distancia = matriz_DTW(end);
    