# Engineering Data Analysis — MATLAB Projects
Danny Kim · Biomedical Engineering, UBC

## About
A collection of MATLAB scripts developed during undergraduate 
biomedical engineering coursework. Projects cover signal processing, 
image processing, statistical analysis, and biomechanics — applied 
to real biomedical datasets.

## Projects

**Signal Processing Analysis**
Processes raw biomedical signal data using Butterworth low-pass 
filtering, downsampling, and FFT-based PSD computation. Extracts 
signal envelopes, detects peaks, and calculates heart rate and RMSE.
Input: .mat file (CSV or MAT format)

**Multichannel Statistics and Threshold Analysis**
Computes per-channel descriptive statistics (mean, median, range, 
standard deviation) across multiple data channels. Calculates time 
each channel exceeds a mean-based threshold.
Input: multichannel CSV data

**Biomedical Image Processing and Enhancement**
Applies median and average filtering to remove noise from biomedical 
images. Performs histogram analysis and contrast adjustment on 
non-background pixels using intensity-based masking.
Input: PNG image file

**EMG Signal Processing and SNR Analysis**
Processes raw EMG data by removing DC offset, applying a 20–450Hz 
bandpass filter, and eliminating 60Hz powerline interference with a 
notch filter. Extracts signal envelope and computes SNR.
Input: .mat file

## Skills demonstrated
Signal processing (FFT, filtering, downsampling) · Statistical 
analysis · Image processing and enhancement · EMG analysis · 
Data visualization · Biomechanics analysis · MATLAB

## How to run
1. Open any .m file in MATLAB
2. Place the corresponding CSV, MAT, or PNG file in the same folder
3. Run the script — outputs display as figures and printed results
   in the Command Window
