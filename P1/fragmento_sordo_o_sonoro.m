function categoria = fragmento_sordo_o_sonoro(s, maximo_autocorrelacion)
    categoria = (maximo_autocorrelacion > 0.3 * energia(s));
end