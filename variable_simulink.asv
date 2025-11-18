clear; close all; clc;

Fs = 1e6;          % fréquence d'échantillonnage
f0 = 24e9;         % fréquence porteuse
B  = 100e6;        % bande FMCW
Tp = 50e-6;        % durée du chirp
k  = B/Tp;         % pente
c  = 3e8;
R_target = 500;
tau = 2*R_target / c;
tau_samples = tau * Fs;
v_target = 20;
lambda = c / f0;
fD = 2*v_target / lambda;
