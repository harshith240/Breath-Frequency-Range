% Step 1: Load the recorded audio file
filename = 'breath.wav'; % Change this to your audio file's name
[y, Fs] = audioread(filename);

% Step 2: Determine the sampling rate
fprintf('Sampling rate of the recorded audio: %d Hz\n', Fs);

% Step 3: Plot the spectrogram to identify frequency content
figure;
spectrogram(y(:,1), hamming(512), 256, 512, Fs, 'yaxis'); % Modify this line to select only one channel if needed
title('Spectrogram of Recorded Breathing');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

% Step 4: Design a low-pass filter to filter out higher frequencies
cutoff_frequency = 500; % Adjust this cutoff frequency as per your requirement
normalized_cutoff_frequency = cutoff_frequency / (Fs/2);
filter_order = 6; % Adjust the filter order as per your requirement

[b, a] = butter(filter_order, normalized_cutoff_frequency, 'low');

% Step 5: Apply the filter to the signal
filtered_signal = filter(b, a, y);

% Step 6: Plot the filtered signal and its spectrogram
figure;
subplot(2,1,1);
plot((0:length(y)-1)/Fs, y);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');
subplot(2,1,2);
plot((0:length(filtered_signal)-1)/Fs, filtered_signal(:,1)); % Modify this line to select only one channel if needed
title('Filtered Signal');
xlabel('Time (s)');
ylabel('Amplitude');

figure;
spectrogram(filtered_signal(:,1), hamming(512), 256, 512, Fs, 'yaxis'); % Modify this line to select only one channel if needed
title('Spectrogram of Filtered Breathing');
xlabel('Time (s)');
ylabel('Frequency (Hz)');
colorbar;

breathing_spectrum = abs(fft(filtered_signal(:,1)));
frequencies = linspace(0, Fs, length(breathing_spectrum));
breathing_spectrum = breathing_spectrum(1:length(breathing_spectrum)/2);
frequencies = frequencies(1:length(frequencies)/2);

[~, peak_indices] = findpeaks(breathing_spectrum, 'MinPeakHeight', max(breathing_spectrum) * 0.1);
min_frequency = frequencies(min(peak_indices));
max_frequency = frequencies(max(peak_indices));
fprintf('Frequency range of the breathing: %.2f Hz to %.2f Hz\n', min_frequency, max_frequency);
