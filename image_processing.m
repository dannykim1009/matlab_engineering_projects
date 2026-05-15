% =========================================================
% Biomedical Image Processing and Enhancement
% =========================================================
% Applies median and average filtering to remove noise,
% displays intensity histogram, and performs contrast
% adjustment on non-background pixels.
%
% Input:  Section3.png
% Output: Filtered and contrast-adjusted image figures
% =========================================================

clear; clc; close all;

%% Load and display original image
imgOriginal = imread("Section3.png");
figure;
imshow(imgOriginal);
title("Original Image");

%% Median filter — remove salt and pepper noise
img_nosaltpepper = medfilt2(imgOriginal);
figure;
imshowpair(imgOriginal, img_nosaltpepper, 'montage');
title("Original vs Median Filtered");

%% Average filter — smooth image
avgFilt      = (1/9) .* ones(3, 3);
img_averaged = uint8(filter2(avgFilt, double(imgOriginal)));
figure;
imshow(img_averaged);
title("Average Filtered");

%% Intensity histogram
% Peak intensity around 150-200 for non-background pixels
figure;
imhist(img_nosaltpepper);
title("Intensity Histogram — Median Filtered Image");

%% Contrast adjustment on non-background pixels
% Intensity range [150 200] selected based on imhist peak
logicArr     = img_nosaltpepper ~= 0;
img_temp     = imadjust(img_nosaltpepper, [150/255, 200/255], []);
img_adjusted = img_nosaltpepper;
img_adjusted(logicArr) = img_temp(logicArr);

figure;
imshowpair(img_nosaltpepper, img_adjusted, 'montage');
title("Before vs After Intensity Adjustment");
