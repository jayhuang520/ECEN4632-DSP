%%%%%%%%%%%%%Final project part I From the wav file to the psychoacoustic
%%%%%%%%%%%%%features
[song,fs] = audioread('track201-classical.wav');
mfcc = zeros(40,517);

%%%% audio files are sampled at fs = 11025 Hz
%fs = 11025; %Or 22050 Hz
%%%%%%%%%%%since the sampling rate is 11025, the FFT size is twice the
%%%%%%%%%%%sampling rate, which its 2 * fs

%%%%%%--------------initialization----------------------
SongLength = length(song)/fs;
Mid = floor(SongLength/2);
%%%%Convert it to time
xn = song(Mid:Mid+24*fs-1);
w = hann(512);
fftsize = 512; %%%%Size of 

for i = 1:40
    mfcc(i,:) = mfcc(xn,fs,fftsize,w);
end
%%%%%%%Take 20log10 of your output,
%use flipud 

imagesc(mfcc);