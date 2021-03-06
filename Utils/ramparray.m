function y = ramparray(a, dur, fs)
%------------------------------------------------------------------------
% y = ramparray(a, dur, fs)
%------------------------------------------------------------------------
% AudioToolbox:Utils
%------------------------------------------------------------------------
%		ramps up and down signal a over duration
%		dur in ms.  fs = sample rate
%
%------------------------------------------------------------------------
% Input Args:
% 	fs = sample rate
% 
% 	signal a is [1, N] or [2, N] array.
%
% 	dur cannot be longer than 1/2 of the total signal duration
%------------------------------------------------------------------------

%------------------------------------------------------------------------
% Sharad Shanbhag
% sshanbhag@neomed.edu
%------------------------------------------------------------------------
% Created: a long time ago...
%
% Revisions:
%	30 Aug 2012 (SJS):	cleaned up comments & documentation 
%------------------------------------------------------------------------

[m, n] = size(a);

rampbins = floor(fs * dur / 1000);

if 2*rampbins > length(a)
	error('ramparray: ramp duration > length of stimulus');
end

ramp1 = linspace(0, 1, rampbins);
ramp2 = linspace(1, 0, rampbins);

y = [(ramp1 .* a(1, 1:rampbins)) ...
		a(1, rampbins + 1:n - rampbins) ...
		(ramp2 .* a(1, n-rampbins+1:n))];

if m == 2
	y2 = [(ramp1 .* a(2, 1:rampbins)) ...
			a(2, rampbins + 1:n - rampbins) ...
			(ramp2 .* a(2, n-rampbins+1:n))];
	y = [y; y2];
end
