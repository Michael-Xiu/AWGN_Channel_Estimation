%%
% Practice1 Task1: Auto-correlation and Cross-correlation of system IO

% Course: Random Signal Analysis, Professor Dai
% Author: Xiu Shengjie, 16308125
% School of Electronics and Information Technology, SYSU
% Date: 5/29/2019

%% fields
clear
close all

%% 1. Input: Gaussian
x =randn(256, 1);

%% 2. Channel: zero-pole -> rational transfer function 
z = [];
p = [0.65+0.65i,0.65-0.65i];
k = 1;
[b, a] = zp2tf(z,p,k);

%% 3. Input goes through Channel
y = filter(b, a, x);  % filters the input data, x, using a rational transfer function defined by the numerator and denominator coefficients b and a, respectively.

%% 4. Additive noise
y_db10 = awgn(y, 10);
y_db20 = awgn(y, 20);

%% 5. Auto-correlation and Cross-correlation
x_auto =  xcorr(x);
y_db10_auto = xcorr(y_db10);
xydb10_corr = xcorr(x,y_db10);

y_db20_auto = xcorr(y_db20);
xydb20_corr = xcorr(x,y_db20);

%% 6. Plot
figure(1)
subplot(311)
plot(x_auto)
xlim([0, 512])
title('R_{xx}')
subplot(312)
plot(y_db10_auto)
xlim([0, 512])
title('R_{yy}')
subplot(313)
plot(xydb10_corr)
xlim([0, 512])
title('R_{xy}')
suptitle('SNR=10dB');

figure(2)
subplot(311)
plot(x_auto)
xlim([0, 512])
title('R_{xx}')
subplot(312)
plot(y_db20_auto)
xlim([0, 512])
title('R_{yy}')
subplot(313)
plot(xydb20_corr)
xlim([0, 512])
title('R_{xy}')
suptitle('SNR=20dB');

