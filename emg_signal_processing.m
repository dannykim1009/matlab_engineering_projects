% =========================================================
% EMG Signal Processing and SNR Analysis
% =========================================================
% Processes raw EMG signal by removing DC offset, applying
% a bandpass filter, removing 60Hz powerline interference
% with a notch filter, and extracting the signal envelope.
% Computes SNR before and after filtering.
%
% Input:  SampleEMG.mat (must be in the same folder)
%         Required variables: x, Fs
% Output: Raw and filtered signal plots, SNR value
% =========================================================

clear; clc; close all;

%% Load data
load("SampleEMG.mat");

t = (0:length(x)-1) / Fs;

%% Plot raw signal
figure;
plot(t, x);
title("Raw EMG Signal");
xlabel("Time (s)");
ylabel("Amplitude");
grid on;

%% DC removal
x_noDC = x - mean(x);

%% Bandpass filter (20–450 Hz) — isolate EMG frequency range
[b_bp, a_bp] = butter(4, [20 450]/(Fs/2), 'bandpass');
sig_band     = filtfilt(b_bp, a_bp, x_noDC);

%% Notch filter — remove 60 Hz powerline interference
wo           = 60/(Fs/2);
bw           = wo/35;
[bn, an]     = iirnotch(wo, bw);
sig_notched  = filtfilt(bn, an, sig_band);

%% Plot filtered signal
figure;
plot(t, sig_notched);
title("Filtered EMG Signal (Bandpass + Notch)");
xlabel("Time (s)");
ylabel("Amplitude");
grid on;

%% SNR calculation
noise         = x_noDC - sig_notched;
p_sig_notched = mean(sig_notched.^2);
p_noise       = mean(noise.^2);
SNR           = 10 * log10(p_sig_notched / p_noise);

%% Envelope extraction
abs_sig      = abs(sig_notched);
[b_env, a_env] = butter(4, 2/(Fs/2), 'low');
sig_env      = filtfilt(b_env, a_env, abs_sig);

%% Plot envelope
figure;
plot(t, sig_notched, 'b', 'DisplayName', 'Filtered Signal');
hold on;
plot(t, sig_env, 'r', 'LineWidth', 1.5, 'DisplayName', 'Envelope');
title("Filtered EMG Signal with Envelope");
xlabel("Time (s)");
ylabel("Amplitude");
legend;
grid on;

%% Print results
fprintf('\n===== SNR Analysis =====\n');
fprintf('Signal Power:  %.6f\n', p_sig_notched);
fprintf('Noise Power:   %.6f\n', p_noise);
fprintf('SNR:           %.2f dB\n', SNR);
fprintf('========================\n');
