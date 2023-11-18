function PLTE = estimate_PLTE(t, t_i,x,x_new)
dx_dt_n_plus_1 = (x_new - x{t_i - 1})/(t(t_i) - t(t_i - 1));
dx_dt_n = (x{t_i - 1} - x{t_i - 2})/(t(t_i - 1) - t(t_i - 2));
dx_dt_n_minus_1 = (x{t_i - 2} - x{t_i - 3})/(t(t_i - 2) - t(t_i - 3));
d2x_dt2_n_plus_1 = (dx_dt_n_plus_1 - dx_dt_n)/(t(t_i) - t(t_i - 2));
d2x_dt2_n = (dx_dt_n - dx_dt_n_minus_1)/(t(t_i - 1) - t(t_i - 3));
PLTE = 0.5 * (t(t_i) - t(t_i - 1))^3 ...
    * (d2x_dt2_n_plus_1 - d2x_dt2_n) / (t(t_i) - t(t_i - 3));
end