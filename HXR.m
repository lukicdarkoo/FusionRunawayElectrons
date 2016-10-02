% Density scan and detection of some Runaways

% Tunning values
hxrSmoothCoef = 2000;
hxrPeakTreshhold = 0.01;

% Find peaks
files = {'tektronix3014_22452.txt'...
    'tektronix3014_22477.txt'...
    'tektronix3014_22479.txt'...
    'tektronix3014_22472.txt'...
    'tektronix3014_22481.txt'
    };
preasures = [19.81, 22.09, 23.64, 26.78, 23.63];



for i = 1:numel(preasures)
    dektronix = importdata(files{i});
    hxrData = dektronix(:, 5);
    
    [hxrPeakValue, hxrPeakIndex] = findpeaks(hxrData, 'THRESHOLD', 0.004, 'MINPEAKDISTANCE', 2);
    
    disp(['Preasure: ', num2str(preasures(i)), '; Peaks: ', num2str(numel(hxrPeakIndex))]);
    
    hold on
    plot(preasures(i), numel(hxrPeakIndex), 'ro')
end



% plot(dektronix(:, 1), hxrData, dektronix(hxrPeakIndex, 1), hxrData(hxrPeakIndex), 'ro')
