function x = clipping(s)
    x = 0.68 * min(max(s(1:80)), max(s(end-80:end)));