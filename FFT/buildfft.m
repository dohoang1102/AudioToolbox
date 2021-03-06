function fftfull = buildfft(fftred)
%-------------------------------------------------------------------------
% fftfull = buildfft(fftred)
%-------------------------------------------------------------------------
% AudioToolbox:FFT
%-------------------------------------------------------------------------
%
%	Given the N+1 points of fftred, buildfft() constructs the length 2N
%	array fftfull
%
%	if y = fft(x):
%		y(1) = constant
%		y(2) = f1
%		y(3) = f2
%		y(1 + N/2) = fmax
%		y(N) = y*(2)
%		y(N-1) = y*(3)
%
%	this function is used by the various synthesis routines 
%-------------------------------------------------------------------------
% Input Arguments:
% 	fftred		complex form of the "single-sided spectrum"
%
%-------------------------------------------------------------------------
% Output Arguments:
% 	fftfull		complex, 2-sided (MATLAB) format spectrum, useful for ifft
%
%-------------------------------------------------------------------------
% See Also: fft, ifft, syn_headphonenoise, syn_headphonenoise_fft
%-------------------------------------------------------------------------
%	Audio Toolbox
%-------------------------------------------------------------------------

%---------------------------------------------------------------------
%	Sharad Shanbhag
%	sshanbhag@neomed.edu
%
%--Revision History---------------------------------------------------
%	12 Feb, 2008, SJS:	created
%	10 Jan, 2009, SJS:
%		- edit comments to make consistent with rest of package
%	23 August, 2010 (SJS): updated comments & documentation
%	6 Sep 2012 (SJS):
%		- updated comments
% 		- fixed issue with length of final vector
%---------------------------------------------------------------------

% N is total number of points in the reduced spectrum
N = length(fftred);
Nunique = N + 1;
% NFFT is length of full spectrum
NFFT = 2*N;

% allocate the net spectrum fftfull
fftfull = zeros(1, NFFT);

%% assign indices into fftfull for the two "sections"
% first portion of fftfull is same as fftred
% also, leave DC component (fftfull(1)) as 0, since it is
% assumed that fftred has only non-DC components
indx1 = 2:Nunique;
% second portion
indx2 = (Nunique+1):NFFT;

fftfull(indx1) = fftred;

% second section is computed as:
%	(1) take fftred(1:(end-1)), since final point (fftred(end)) 
% 		 is common to both sections
% 	(2) flip the fftred section around using fliplr (reverse order)
% 	(3) take complex conjugate of flipped fftred
fftfull(indx2) = conj(fliplr(fftred(1:(end-1))));



