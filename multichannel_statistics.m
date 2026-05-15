% =========================================================
% Multichannel Signal Statistics and Threshold Analysis
% =========================================================
% Reads multichannel CSV data, computes descriptive statistics
% per channel, and calculates time each channel exceeds a
% mean-based threshold.
%
% Input:  Section2.csv (first column = time, rest = channels)
% Output: Per-channel statistics and threshold-exceeded time
% =========================================================

clear; clc;

%% Load data
raw  = readtable("Section2.csv");
data = table2array(raw);
data = data(:, 2:end);  % remove time column

%% Descriptive statistics per channel
ch_mean   = mean(data);
ch_median = median(data);
ch_range  = range(data);
ch_std    = std(data);

[max_mean,   idx_max_mean]   = max(ch_mean);
[min_mean,   idx_min_mean]   = min(ch_mean);
[max_median, idx_max_median] = max(ch_median);
[min_median, idx_min_median] = min(ch_median);
[max_range,  idx_max_range]  = max(ch_range);
[min_range,  idx_min_range]  = min(ch_range);
[max_std,    idx_max_std]    = max(ch_std);
[min_std,    idx_min_std]    = min(ch_std);

%% Threshold analysis (mean + 20 per channel)
threshold  = ch_mean + 20;
pass       = data > threshold;
num_passed = sum(pass, 1);
time_passed = (num_passed * 5) / 3600;  % 5s intervals, convert to hours

%% Print results
fprintf('\n===== Per-Channel Statistics =====\n');
fprintf('Highest mean:   Channel %d (%.4f)\n', idx_max_mean,   max_mean);
fprintf('Lowest mean:    Channel %d (%.4f)\n', idx_min_mean,   min_mean);
fprintf('Highest median: Channel %d (%.4f)\n', idx_max_median, max_median);
fprintf('Lowest median:  Channel %d (%.4f)\n', idx_min_median, min_median);
fprintf('Highest range:  Channel %d (%.4f)\n', idx_max_range,  max_range);
fprintf('Lowest range:   Channel %d (%.4f)\n', idx_min_range,  min_range);
fprintf('Highest std:    Channel %d (%.4f)\n', idx_max_std,    max_std);
fprintf('Lowest std:     Channel %d (%.4f)\n', idx_min_std,    min_std);

fprintf('\n===== Threshold Analysis =====\n');
fprintf('Time above threshold per channel (hours):\n');
disp(time_passed);
fprintf('==============================\n');
