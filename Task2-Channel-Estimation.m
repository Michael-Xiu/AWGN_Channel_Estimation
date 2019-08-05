%%
% Practice1 Task2: Channel Estimation based on Auto-correlation

% Course: Random Signal Analysis, Professor Dai
% Author: Xiu Shengjie, 16308125
% School of Electronics and Information Technology, SYSU
% Date: 5/29/2019

%% fields
clear
close all

times = 100;
MMSE = zeros(4,5);

%% 0. rational transfer function -> frequency response
b = [1, 0.75, 0.8, 0.5, 0.3];
a = 1;
h = impz(b, a);


for dB = 0:10:30
    
MSE_sum = 0;

for k = 1: times;
    
%% 1. Input: Gaussian
x =randn(256, 1);

%% 2. Input goes through Channel
y = conv(x, h);

%% 3. Additive noise
y = awgn(y, dB);

%% 4. Estimation based on Auto-correlation
x_auto =  xcorr(x);
x_auto_0 = x_auto(256);

b_hat = zeros([1,5]);

for l = 1:5
    b_hat(l) = mean(x .* y(l:l+255))/(x_auto_0/256);
end


%% 6. Error: MSE
MSE = (b-b_hat).^2 ./ b.^2;
MSE_sum = MSE_sum+MSE;


end
MMSE(dB/10+1, :) = MSE_sum / times;

end

%% Plot: bar
bar = bar(MMSE');
l = cell(1,4);
l{1}='0dB'; l{2}='10dB'; l{3}='20dB'; l{4}='30dB';  
legend(l,'Location','northwest');
title('\bfChannel Estimation')
xlabel('\bfh(l)')
ylabel('\bfMMSE')

disp(MMSE)