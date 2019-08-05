%%
% Practice1 Task3: Acquire Power Spectrum in three methods

% Course: Random Signal Analysis, Professor Dai
% Author: Xiu Shengjie, 16308125
% School of Electronics and Information Technology, SYSU
% Date: 5/29/2019

%% fields
clear
close all

%% 1. Input: Gaussian
x =wgn(2048, 1,0);

%% 2. Channel: zero-pole -> rational transfer function
z = [];
p = [0.65+0.65i,0.65-0.65i];
k = 1;
[b, a] = zp2tf(z,p,k);

%% 3. Input goes through Channel
y = filter(b, a, x);

for SNR =[10, 20]
y = awgn(y, SNR);

%% Method1: |FFT|^2
y_fft = abs(fft(y));
y_PSD_1 = y_fft.^2;
y_PSD_1 = y_PSD_1(1:floor(length(y_PSD_1)/2)+1);
y_PSD_1_smooth = medfilt1(y_PSD_1, 10);

w1 = (0 : 1/(length(y_PSD_1)-1) : 1);


%% Method2: FFT(Ryy)
Ryy = xcorr(y, y);
y_PSD_2 = abs(fft(Ryy));
y_PSD_2 = y_PSD_2(1:floor(length(y_PSD_2)/2)+1);
y_PSD_2_smooth = medfilt1(y_PSD_2, 10);

w2 = (0 : 1/(length(y_PSD_2)-1) : 1);


%% Method3: AR based estimation
a_AR = arburg(y, 10);  % burg method

[h_AR,w3] = freqz(1, a_AR);  % frequency response for visualization
y_PSD_3 = (abs(h_AR) * mean(medfilt1(abs(fft(x)), 10))).^2;  % latter is average white noise PSD of x

%% plot
figure(SNR)
hold on
grid on
plot(w1, 20*log10(y_PSD_1_smooth), 'color',[255 255 0]/255,'LineWidth', 1);
plot(w2, 20*log10(y_PSD_2_smooth), 'color',[152 251 152]/255, 'LineWidth', 1);
plot(w3/pi,20*log10(y_PSD_3), 'color',[	255 106 106]/255, 'LineWidth', 1);
ylim([20, 120])
legend('|FFT|^2', 'FFT(Ryy)', 'AR based')
xlabel('\omega (\pi)')
ylabel('PSD(dB)')
title(['PSD of y' , '  (SNR=', num2str(SNR), 'dB)'] )
hold off

end

figure(polezero)
fvtool(b,a,'Analysis','polezero')