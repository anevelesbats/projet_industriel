clear; close all; clc;

%% ===========================================
%             PARAMETRES FMCW
% ===========================================
c = 3e8;

B  = 100e6;     % Bande de la rampe
Tp = 50e-6;     % Durée d'une rampe (50 µs)
Fs = 5e9;       % Echantillonnage élevé pour un beau dessin
f0 = 24e9;      % Porteuse 24 GHz (radar auto)

Nchirps = 3;    % 🔥 nombre de rampes à afficher

R_target = 500; % 🔥 distance cible augmentée pour un délai visible
v_target = 20;  % vitesse radiale

k = B / Tp;     % pente de la rampe

%% ===========================================
%        TEMPS POUR PLUSIEURS RAMPE
% ===========================================
Ttot = Nchirps * Tp;
t = (0:1/Fs:Ttot-1/Fs).';

% Index dans une rampe (modulo Tp)
t_ramp = mod(t, Tp);

%% ===========================================
%            SIGNAL TRANSMIS FMCW
% ===========================================
f_tx = f0 + k * t_ramp;   % rampe répétée

%% ===========================================
%            SIGNAL ÉCHO RETARDÉ
% ===========================================
tau = 2*R_target/c;          % délai
fD  = 2*v_target/(c/f0);      % Doppler

t_echo = t - tau;
t_echo_ramp = mod(t_echo, Tp);

% fréquence reçue
f_rx = f0 + k * t_echo_ramp + fD;

% supprimer les indices invalides (avant le début)
f_rx(t_echo < 0) = NaN;

%% ===========================================
%             AFFICHAGE MULTI-RAMPE
% ===========================================
figure;
plot(t*1e6, f_tx/1e9, 'r', 'LineWidth', 1.5); hold on;
plot(t*1e6, f_rx/1e9, 'g--', 'LineWidth', 1.8);

xlabel('Temps (µs)');
ylabel('Fréquence instantanée (GHz)');
title('FMCW : rampes multiples, signal transmis et écho retardé');
legend('Signal transmis', 'Écho reçu');
grid on;

%% ===========================================
%             CALCUL BEAT FREQUENCY
% ===========================================
fbeat = k * tau + fD;

% Distance estimée
R_est = (fbeat * c * Tp) / (2 * B);

fprintf("\n===========  RESULTATS  =================\n");
fprintf("τ (retard) = %.3e s\n", tau);
fprintf("fbeat = %.2f Hz\n", fbeat);
fprintf("Distance estimée = %.1f m (réelle %.1f m)\n\n", R_est, R_target);
