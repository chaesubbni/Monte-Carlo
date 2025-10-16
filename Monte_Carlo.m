clear; clc; rng(0);

% ---- 사양(단위 주의) ----
% L: 1.5 mH ±10%  → [1.35, 1.65] mH
% C: 0.27 μF ±5%  → [0.2565, 0.2835] μF
Lmin_mH = 1.35; Lmax_mH = 1.65;
Cmin_uF = 0.2565; Cmax_uF = 0.2835;

% 단위 변환
Lmin = Lmin_mH*1e-3;  Lmax = Lmax_mH*1e-3;   % H
Cmin = Cmin_uF*1e-6;  Cmax = Cmax_uF*1e-6;   % F

% 이론 범위(최소/최대) 계산
fmin = 1/(2*pi*sqrt(Lmax*Cmax));
fmax = 1/(2*pi*sqrt(Lmin*Cmin));

% ---- 샘플 수 ----
N = 1000;

% ---- Uniform 샘플 (rand) ----
Lu = Lmin + (Lmax-Lmin)*rand(1,N);
Cu = Cmin + (Cmax-Cmin)*rand(1,N);
fu = 1./(2*pi*sqrt(Lu.*Cu));    % 벡터화 계산

% ---- Normal 샘플 (randn) ----
% 평균과 표준편차: 허용오차를 μ±3σ 정도로 가정(실습 전형)
muL = (Lmin+Lmax)/2;  sigmaL = (Lmax-Lmin)/(2*3);
muC = (Cmin+Cmax)/2;  sigmaC = (Cmax-Cmin)/(2*3);
Ln = muL + sigmaL*randn(1,N);
Cn = muC + sigmaC*randn(1,N);
% 물리적으로 말이 안 되는 음수 제거 → 범위로 클리핑(선택 사항)
Ln = min(max(Ln,Lmin),Lmax);
Cn = min(max(Cn,Cmin),Cmax);
fn = 1./(2*pi*sqrt(Ln.*Cn));

% ---- 히스토그램 표시 ----
figure('Color','w'); tiledlayout(1,2,'Padding','compact','TileSpacing','compact');

% Uniform
nexttile;
histogram(fu, 'Normalization','pdf'); hold on;
xline(fmin,'--','f_{min}'); xline(fmax,'--','f_{max}');
title('Uniform (rand)'); xlabel('Frequency (Hz)'); ylabel('PDF'); grid on;

% Normal
nexttile;
histogram(fn, 'Normalization','pdf'); hold on;
xline(fmin,'--','f_{min}'); xline(fmax,'--','f_{max}');
title('Normal (randn)'); xlabel('Frequency (Hz)'); ylabel('PDF'); grid on;

% ---- 요약 통계 ----
stats = table( ...
    [min(fu); mean(fu); max(fu)], ...
    [min(fn); mean(fn); max(fn)], ...
    'RowNames', {'min','mean','max'}, 'VariableNames', {'Uniform','Normal'});
disp(stats);

fprintf('Theoretical range: fmin = %.2f Hz, fmax = %.2f Hz\n', fmin, fmax);