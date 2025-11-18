clear; close all; clc;

%% ===============================
%     SCENARIO RADAR POLAIRE
% ===============================
dt = 0.1;
Tf = 30;
N = floor(Tf/dt);

% État réel (x,y,vx,vy)
x_true = zeros(4,N);
x_true(:,1) = [50; 0; 20; 5];

for k = 2:N
    x = x_true(:,k-1);
    ax = 0.2*sin(0.15*k);
    ay = 0.1*cos(0.21*k);
    vx = x(3) + ax*dt;
    vy = x(4) + ay*dt;
    x_true(:,k) = [x(1) + vx*dt; x(2) + vy*dt; vx; vy];
end

%% ===============================
%       MESURES POLAIRES
% ===============================
noise_r = 5;
noise_b = deg2rad(2);

z = zeros(2,N);
for k = 1:N
    r = sqrt(x_true(1,k)^2 + x_true(2,k)^2);
    b = atan2(x_true(2,k), x_true(1,k));
    z(:,k) = [r + noise_r*randn(); b + noise_b*randn()];
end

%% ===============================
%           MODELES
% ===============================
A = [1 0 dt 0;
     0 1 0 dt;
     0 0 1 0;
     0 0 0 1];

Q = 0.1 * eye(4);
R = diag([noise_r^2, noise_b^2]);

H_nl = @(x) [sqrt(x(1)^2 + x(2)^2);
             atan2(x(2),x(1))];

H_jac = @(x) [ x(1)/sqrt(x(1)^2+x(2)^2), x(2)/sqrt(x(1)^2+x(2)^2), 0, 0;
              -x(2)/(x(1)^2+x(2)^2),    x(1)/(x(1)^2+x(2)^2),    0, 0];

%% ===============================
%    INIT DES 3 FILTRES
% ===============================
x0 = [40; -20; 10; 0];
P0 = 300*eye(4);

x_kf  = x0;   P_kf  = P0;
x_ekf = x0;   P_ekf = P0;
x_ukf = x0;   P_ukf = P0;

kf_hist  = zeros(4,N);
ekf_hist = zeros(4,N);
ukf_hist = zeros(4,N);

%% ===============================
%            TRACKING
% ===============================
alpha=1e-3; beta=2; kappa=0;

for k = 1:N

    %% -------- KF (FAUX MODELE H LINEAIRE) ----------
    % prédiction
    x_kf = A*x_kf;
    P_kf = A*P_kf*A' + Q;

    % linéarisation grossière (exprès) pour montrer le biais KF
    H_lin = H_jac(x_kf);

    z_pred = H_nl(x_kf);
    K = P_kf * H_lin' / (H_lin*P_kf*H_lin' + R);

    x_kf = x_kf + K*(z(:,k) - z_pred);
    P_kf = (eye(4)-K*H_lin)*P_kf;

    kf_hist(:,k) = x_kf;


    %% -------- EKF ----------
    x_ekf = A*x_ekf;
    P_ekf = A*P_ekf*A' + Q;

    Hk = H_jac(x_ekf);
    z_pred = H_nl(x_ekf);

    K = P_ekf*Hk'/(Hk*P_ekf*Hk'+R);

    x_ekf = x_ekf + K*(z(:,k) - z_pred);
    P_ekf = (eye(4)-K*Hk)*P_ekf;

    ekf_hist(:,k) = x_ekf;


    %% -------- UKF ----------
    [X,Wm,Wc] = sigma_points(x_ukf,P_ukf,alpha,beta,kappa);

    % prédiction
    Xpred = A*X;
    xpred = Xpred*Wm';
    Ppred = Q;
    for i=1:size(Xpred,2)
        dx = Xpred(:,i) - xpred;
        Ppred = Ppred + Wc(i)*(dx*dx');
    end

    % projection mesure
    Zsig = zeros(2,size(Xpred,2));
    for i=1:size(Xpred,2)
        Zsig(:,i) = H_nl(Xpred(:,i));
    end

    zpred = Zsig*Wm';
    Pz = R;
    Pxz = zeros(4,2);

    for i=1:size(Zsig,2)
        dz = Zsig(:,i)-zpred;
        dx = Xpred(:,i)-xpred;
        Pz = Pz + Wc(i)*(dz*dz');
        Pxz = Pxz + Wc(i)*(dx*dz');
    end

    K = Pxz/Pz;

    x_ukf = xpred + K*(z(:,k) - zpred);
    P_ukf = Ppred - K*Pz*K';

    ukf_hist(:,k) = x_ukf;
end

%% ===============================
%      ANIMATION 2D TEMPS RÉEL
% ===============================
figure; hold on; grid on; axis equal;
xlabel('x (m)'); ylabel('y (m)');
title('Tracking radar 2D : KF (rouge), EKF (vert), UKF (bleu)');

xlim([-50 600]);
ylim([-200 300]);

for k=1:N
    cla;
    plot(x_true(1,1:k), x_true(2,1:k), 'k', 'LineWidth', 2);
    plot(z(1,1:k).*cos(z(2,1:k)), z(1,1:k).*sin(z(2,1:k)), '.', 'Color',[0.7 0.7 0.7]);

    plot(kf_hist(1,1:k),  kf_hist(2,1:k),  'r', 'LineWidth', 1.5);
    plot(ekf_hist(1,1:k), ekf_hist(2,1:k), 'g', 'LineWidth', 1.5);
    plot(ukf_hist(1,1:k), ukf_hist(2,1:k), 'b', 'LineWidth', 1.5);

    legend('Trajectoire réelle','Mesures','KF','EKF','UKF', ...
        'Location','bestoutside');

    drawnow;
    pause(0.05);
end

%% ===============================
%  UTIL : sigma-points UKF
% ===============================
function [X,Wm,Wc] = sigma_points(x,P,alpha,beta,kappa)
    n = length(x);
    lambda = alpha^2*(n+kappa)-n;
    S = chol((n+lambda)*P,'lower');

    X = [x, x+S, x-S];
    Wm = [lambda/(n+lambda), repmat(1/(2*(n+lambda)),1,2*n)];
    Wc = Wm;
    Wc(1)=Wc(1)+(1-alpha^2+beta);
end
