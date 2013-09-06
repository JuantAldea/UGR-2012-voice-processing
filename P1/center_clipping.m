function x = center_clipping(s, umbral)
    x = sign(s) .* max(abs(s) - umbral, 0);