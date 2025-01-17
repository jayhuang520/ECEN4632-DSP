function [ output ] = mfcc( wav,fs,fftSize, window )
%   MFCC(Mel-frequency cepstral coefficients)
%
%USAGE
%  [mfcc] = mfcc(wav, fs, fftSize,window)
%
%INPUT
%  vector of wav samples
%  fs: sampling frequency
%  fftSize:size of fft
%  window: a window of size fftSize
%
%OUTPUT
%  mfcc (matrix size) coefficients x nFrames
%  harewired parameters


hopSize = fftSize/2;
nBanks = 40;

% minimum and maximum frequencies for the analysis
fMin = 20;
fMax = fs/2;
%_____________________________________________________________________
%
% PART 1 : construction of the filters in the frequency domain
%_____________________________________________________________________
% generate the linear frequency scale of equally spaced frequencies from 0 to fs/2.
linearFreq = linspace(0,fs/2,hopSize+1);
fRange = fMin:fMax;
% map the linear frequency scale of equally spaced frequencies from 0 to fs/2
% to an unequally spaced mel scale.
melRange = log(1+fRange/700)*1127.01048;

% The goal of the next coming lines is to resample the mel scale to create uniformly
% spaced mel frequency bins, and then map this equally spaced mel scale to the linear
%& scale.
% divide the mel frequency range in equal bins
melEqui = linspace (1,max(melRange),nBanks+2);
fIndex = zeros(nBanks+2,1);
% for each mel frequency on the equally spaces grid, find the closest frequency on the
% unequally spaced mel scale
for i=1:nBanks+2
    [dummy,fIndex(i)] = min(abs(melRange - melEqui(i)));
end
% Now, we have the indices of the equally-spaced mel scale that match the unequally-spaced
% mel grid. These indices match the linear frequency, so we can assign a linear frequency
% for each equally-spaced mel frequency
fEquiMel = fRange(fIndex);
% Finally, we design of the hat filters. We build two arrays that correspond to the center,
% left and right ends of each triangle.
fLeft = fEquiMel(1:nBanks);
fCentre = fEquiMel(2:nBanks+1);
fRight = fEquiMel(3:nBanks+2);
% clip filters that leak beyond the Nyquist frequency
[dummy,tmp.idx] = max(find(fCentre <= fs/2));
nBanks = min(tmp.idx,nBanks);
% this array contains the frequency response of the nBanks hat filters.
freqResponse = zeros(nBanks,fftSize/2+1);
hatHeight = 2./(fRight-fLeft);

% for each filter, we build the left and right edge of the hat.
for i=1:nBanks
    freqResponse(i,:) = ...
    (linearFreq > fLeft(i) & linearFreq <= fCentre(i)).* ...
    hatHeight(i).*(linearFreq-fLeft(i))/(fCentre(i)-fLeft(i)) + ...
    (linearFreq > fCentre(i) & linearFreq < fRight(i)).* ...
    hatHeight(i).*(fRight(i)-linearFreq)/(fRight(i)-fCentre(i));
end
%
% plot a pretty figure of the frequency response of the filters.
% figure;set(gca,'fontsize',14);
% semilogx(linearFreq,freqResponse');
% axis([0 fRight(nBanks) 0 max(freqResponse(:))]);title('FilterbankS');
%_________________________________________________________
%
% PART 2 : processing of the audio vector In the Fourier domain.
%_________________________________________________________
%
% YOU NEED TO ADD YOUR CODE HERE
   xn = wav(1:fftSize);
   Y = fft(xn.*window);
   K = fftSize/2+1;
   Xn = Y(1:K);
   output = (abs(freqResponse*Xn)).^2;
end

