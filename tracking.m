clear; close all; clc;
%% 
% Le filtre de Kalman est l'algorithme de référence pour le tracking linéaire
% avec bruits gaussiens.
% Il donne l'estimation optimale (au sens MMSE) de l'état.

%% ===============================
%     PARAMÈTRES DE LA SIMULATION
% ===============================
dt = 0.1;         % période radar
T = 20;           % durée totale
N = T/dt;         % nombre d'itérations

% Trajectoire réelle (exemple : cible avance + accélère)
pos_true  = zeros(1,N);
vel_true  = zeros(1,N);

pos_true(1) = 0;
vel_true(1) = 20;   % 20 m/s

acceleration = 1;   % m/s²

for k = 2:N
    vel_true(k) = vel_true(k-1) + acceleration*dt;
    pos_true(k) = pos_true(k-1) + vel_true(k-1)*dt;
end

%% ===================================
%      MESURES BRUITÉES DU RADAR
% ===================================
noise_std = 20;  % bruit énorme pour bien visualiser

z = pos_true + noise_std * randn(1,N);

%% ===================================
%        FILTRE DE KALMAN
% ===================================
A = [1 dt; 0 1];
H = [1 0];
Q = [1 0; 0 1];   % bruit de modélisation
R = noise_std^2;  % bruit de mesure

x = [0; 10];      % estimation initiale
P = eye(2);

x_est = zeros(2,N);

for k = 1:N
    % ----- PRÉDICTION -----
    x = A*x;
    P = A*P*A' + Q;

    % ----- MISE À JOUR -----
    K = P*H'/(H*P*H' + R);
    x = x + K*(z(k) - H*x);
    P = (eye(2)-K*H)*P;

    x_est(:,k) = x;
end

%% ===================================
%       ANIMATION DU TRACKING 🎬
% ===================================
figure; hold on; grid on;
title('Tracking cible radar : réel vs mesures vs Kalman');
xlabel('Temps (s)');
ylabel('Position (m)');
ylim([min(z)-50 max(z)+50]);

for k = 1:N
    cla;
    plot((1:k)*dt, pos_true(1:k), 'b', 'LineWidth', 2); hold on;   % réel
    plot((1:k)*dt, z(1:k), 'k.');                                 % mesures
    plot((1:k)*dt, x_est(1,1:k), 'r', 'LineWidth', 2);             % Kalman

    legend('Position réelle', 'Mesures radar', 'Estimation Kalman');
    drawnow;
end
