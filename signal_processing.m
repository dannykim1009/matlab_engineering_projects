% =========================================================
% Biomedical Signal Processing Analysis
% =========================================================
% Computes PSD, applies Butterworth low-pass filter,
% downsamples signals, extracts envelopes, detects peaks,
% and calculates heart rate and RMSE.
%
% Input:  Section1.mat (must be in the same folder)
%         Required variables: sig1, sig2, Fs
% Output: PSD plots, envelope plots, HR and RMSE values
% =========================================================

clear; clc; close all;

%% Load data
load("Section1.mat")

%% Parameters
fcut  = 90;   % low-pass cutoff frequency (Hz)
f_ds  = 200;  % target sampling frequency after downsampling (Hz)
f_low = 20;   % lower bound for power calculation (Hz)
f_high = 100; % upper bound for power calculation (Hz)

%% Time vector (original)
t = 0:1/Fs:1-1/Fs;

%% --- Original PSD ---
N1    = length(sig1);
xdft1 = fft(sig1);
xdft1 = xdft1(1:N1/2+1);
psdx1 = (1/(Fs*N1)) * abs(xdft1).^2;
psdx1(2:end-1) = 2*psdx1(2:end-1);
freq1 = 0:Fs/N1:Fs/2;

N2    = length(sig2);
xdft2 = fft(sig2);
xdft2 = xdft2(1:N2/2+1);
psdx2 = (1/(Fs*N2)) * abs(xdft2).^2;
psdx2(2:end-1) = 2*psdx2(2:end-1);
freq2 = 0:Fs/N2:Fs/2;

figure;
plot(freq1, psdx1, 'r')
hold on
plot(freq2, psdx2, 'b')
title("Original PSD — Signal 1 and Signal 2")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")
legend("Signal 1", "Signal 2")
grid on

% Band power (20–100 Hz)
f1_within = freq1 >= f_low & freq1 <= f_high;
f2_within = freq2 >= f_low & freq2 <= f_high;
power1 = trapz(freq1(f1_within), psdx1(f1_within));
power2 = trapz(freq2(f2_within), psdx2(f2_within));

%% --- Butterworth Low-Pass Filter ---
[b1, a1] = butter(4, fcut/(Fs/2), 'low');
[b2, a2] = butter(4, fcut/(Fs/2), 'low');
sig1_low = filtfilt(b1, a1, sig1);
sig2_low = filtfilt(b2, a2, sig2);

%% --- Downsampling ---
ds_factor = round(Fs/f_ds);
sig1_ds = downsample(sig1_low, ds_factor);
sig2_ds = downsample(sig2_low, ds_factor);
t1_ds = (0:length(sig1_ds)-1) / f_ds;
t2_ds = (0:length(sig2_ds)-1) / f_ds;

%% --- Downsampled PSD ---
N1_ds    = length(sig1_ds);
xdft1_ds = fft(sig1_ds);
xdft1_ds = xdft1_ds(1:N1_ds/2+1);
psdx1_ds = (1/(f_ds*N1_ds)) * abs(xdft1_ds).^2;
psdx1_ds(2:end-1) = 2*psdx1_ds(2:end-1);
freq1_ds = 0:f_ds/N1_ds:f_ds/2;

N2_ds    = length(sig2_ds);
xdft2_ds = fft(sig2_ds);
xdft2_ds = xdft2_ds(1:N2_ds/2+1);
psdx2_ds = (1/(f_ds*N2_ds)) * abs(xdft2_ds).^2;
psdx2_ds(2:end-1) = 2*psdx2_ds(2:end-1);
freq2_ds = 0:f_ds/N2_ds:f_ds/2;

figure;
plot(freq1_ds, psdx1_ds, 'r')
hold on
plot(freq2_ds, psdx2_ds, 'b')
title("Downsampled PSD — Signal 1 and Signal 2")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency")
legend("Signal 1", "Signal 2")
grid on

% Downsampled band power
idx1_ds = freq1_ds >= f_low & freq1_ds <= f_high;
idx2_ds = freq2_ds >= f_low & freq2_ds <= f_high;
power1_ds = trapz(freq1_ds(idx1_ds), psdx1_ds(idx1_ds));
power2_ds = trapz(freq2_ds(idx2_ds), psdx2_ds(idx2_ds));

%% --- Envelope Extraction ---
sig1_rect = abs(sig1_ds);
sig2_rect = abs(sig2_ds);

[b3, a3] = butter(2, 2/(f_ds/2), 'low');
env1 = filtfilt(b3, a3, sig1_rect);
env2 = filtfilt(b3, a3, sig2_rect);

figure;
plot(t1_ds, env1, 'r');
hold on;
plot(t2_ds, env2, 'b');
title("Envelopes of Downsampled Signals");
xlabel("Time (s)");
ylabel("Amplitude");
legend("Envelope Signal 1", "Envelope Signal 2");
grid on;

%% --- Peak Detection and Heart Rate ---
[~, locs1] = findpeaks(env1, "MinPeakProminence", 0.1);
[~, locs2] = findpeaks(env2, "MinPeakProminence", 0.1);

RR1 = diff(locs1) / f_ds;
RR2 = diff(locs2) / f_ds;
HR1 = 60 / mean(RR1);
HR2 = 60 / mean(RR2);

%% --- Interpolation and RMSE ---
sigint1 = interp1(t1_ds, sig1_ds, t, "linear");
sigint2 = interp1(t2_ds, sig2_ds, t, "linear");

rmse1 = sqrt(mean((sig1 - sigint1).^2, 'omitnan'));
rmse2 = sqrt(mean((sig2 - sigint2).^2, 'omitnan'));

%% --- Print Results ---
fprintf('\n===== Results =====\n');
fprintf('Band Power (original)    — Signal 1: %.4f  |  Signal 2: %.4f\n', power1, power2);
fprintf('Band Power (downsampled) — Signal 1: %.4f  |  Signal 2: %.4f\n', power1_ds, power2_ds);
fprintf('Heart Rate               — Signal 1: %.1f bpm  |  Signal 2: %.1f bpm\n', HR1, HR2);
fprintf('RMSE                     — Signal 1: %.4f  |  Signal 2: %.4f\n', rmse1, rmse2);
fprintf('===================\n');
