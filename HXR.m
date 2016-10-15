% Density scan and detection of some Runaways
clear;

% Tunning values
hxrMinPeakHeight = 0;
hxrMinPeakDistance = 5;
hxrThreshold = 0.004;
hxrNPeaks = 0;
hxrSortStr = 'none';


% Import data & find peaks
files = {'data/tektronix3014_22452.txt'...
    'data/tektronix3014_22477.txt'...
    'data/tektronix3014_22479.txt'...
    'data/tektronix3014_22472.txt'...
    'data/tektronix3014_22481.txt'
    };
preasures = [19.81, 22.09, 23.64, 26.78, 23.63];

for i = 1:numel(preasures)
    dektronix = importdata(files{i});
    hxrData = dektronix(:, 5);
    
    [hxrPeakValue, hxrPeakIndex] = findpeaks(hxrData, hxrMinPeakHeight, hxrMinPeakDistance, hxrThreshold, hxrNPeaks, hxrSortStr);
    
    disp(['Preasure: ', num2str(preasures(i)), '; Peaks: ', num2str(numel(hxrPeakIndex))]);
    
    hold on
    plot(preasures(i), numel(hxrPeakIndex), 'ro')
end



% plot(dektronix(:, 1), hxrData, dektronix(hxrPeakIndex, 1), hxrData(hxrPeakIndex), 'ro')
