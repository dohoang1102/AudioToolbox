function caldata = readearcal(filename)
% function caldata = readearcal(filename)
%
%	Function to read in calibration data generated by the Xcalibur program.
%
%	Input Arguments:
%		filename		= 	name of cal file (usually ear.cal)
%	
%	Output Arguments:
%		caldata			= 	Matlab structure containing cal data
%			Critical elements are
%				caldata.mag	
%				caldata.phase
%				These are both 2XN arrays, with the first row containing
%				data for the Left channel and the second row containing
%				Right channel data.  This is the convention for all the
%				calibration data
%
% Sharad J. Shanbhag
% sharad@etho.caltech.edu
% Version 1.00

fp = fopen(filename, 'r', 'n');
if fp == -1
	warning('readearcal: could not open file');
	caldata = NaN;
	return
end
%endloc = fsize(fp);

%Global Header:
s = sscanf(fgets(fp), '%s %s %s %s %f');
caldata.version = s(length(s));
for i = 1:3	s = fgets(fp);end	% skip three lines

caldata.range = read_cal_val(fp);
caldata.mono = read_cal_val(fp);
caldata.max_spl = read_cal_val(fp, 'd');
caldata.min_spl = read_cal_val(fp, 'd');
caldata.auto_step = read_cal_val(fp, 'd');
caldata.atten = read_cal_val(fp, 'd');
caldata.check = read_cal_val(fp, 'd');
caldata.check_file = read_cal_val(fp, 's');
caldata.depvar = read_cal_val(fp, 's');
s = fgets(fp);					% skip line

caldata.reps = read_cal_val(fp, 'd');
caldata.dur = read_cal_val(fp, 'd');
caldata.rise = read_cal_val(fp, 'd');
caldata.fall = read_cal_val(fp, 'd');
caldata.mic_adj_l = read_cal_val(fp, 'd');
caldata.mic_adj_r = read_cal_val(fp, 'd');
caldata.so_l = read_cal_val(fp, 'f');
caldata.so_r = read_cal_val(fp, 'f');
caldata.gain_l = read_cal_val(fp, 'f');
caldata.gain_r = read_cal_val(fp, 'f');
caldata.invert_l = read_cal_val(fp, 'f');
caldata.invert_r = read_cal_val(fp, 'f');
caldata.speaker_channel = read_cal_val(fp, 's');
caldata.reference_channel = read_cal_val(fp, 's');
caldata.daFc = read_cal_val(fp, 'f');
caldata.adFc = read_cal_val(fp, 'f');
caldata.version_str = read_cal_val(fp, 'R');
caldata.time_str = read_cal_val(fp, 'R');
for i = 1:23	s = fgets(fp);end	% skip three lines
caldata.nrasters = read_cal_val(fp, 'd');

caldata.freq = zeros(1, caldata.nrasters);
caldata.mag = zeros(2, caldata.nrasters);
caldata.phase = caldata.mag;
caldata.dist = caldata.mag;
caldata.leak_mag = caldata.mag;
caldata.leak_phase = caldata.mag;
caldata.leak_dist = caldata.mag;
caldata.mag_stderr = caldata.mag;
caldata.phase_stderr = caldata.mag;

% now read the frequency data
for i = 1:caldata.nrasters
	s = sscanf(fgets(fp), '%f', 17);
	caldata.freq(i) 			= s(1);
 %L channel data
	caldata.mag(1, i) 			= s(2);
	caldata.phase(1, i) 		= s(3);
	caldata.dist(1, i) 			= s(4);
	caldata.leak_mag(1, i)		= s(5);
	caldata.leak_phase(1, i)	= s(6);
	caldata.leak_dist(1, i) 	= s(7);
%R channel data
	caldata.mag(2, i) 			= s(8);
	caldata.phase(2, i) 		= s(9);
	caldata.dist(2, i) 			= s(10);
	caldata.leak_mag(2, i)		= s(11);
	caldata.leak_phase(2, i)	= s(12);
	caldata.leak_dist(2, i) 	= s(13);

%stats for L and R mag and phase
	caldata.mag_stderr(1, i) 	= s(14);
	caldata.phase_stderr(1, i)	= s(15);
	caldata.mag_stderr(2, i) 	= s(16);
	caldata.phase_stderr(2, i)	= s(17);
end

fclose(fp);

% convert phases from angle (RADIANS) to microsecond
caldata.phase(1, :) = (unwrap(caldata.phase(1, :)).*caldata.freq) * 2 * pi * 1e-6;
caldata.phase(2, :) = (unwrap(caldata.phase(2, :)).*caldata.freq) * 2 * pi * 1e-6;



function [value, tag] = read_cal_val(fp, type_spec)
% subfunction, reads in a line from file stream fp,
% scans for the = sign, then reads value of type 
% TYPE_SPEC where
% TYPE_SPEC is 
%	f -> float
%	d -> int
%	c -> char
% 	R -> raw
%	s -> string
%

if fp == -1
	error('read_cal_val: null file pointer')
end

if nargin == 1
	type_spec = 'R';
end
	
s = fgets(fp);

i_arg = find(s=='=');
if i_arg == length(s)
	value = '';
else
	value = s(i_arg+1:length(s));
end

switch type_spec
	case 'f'
		value = sscanf(value, '%f');
	case 'd'
		value = sscanf(value, '%d');
	case 'c'
		value = sscanf(value, '%c');
	case 'R'
		value = value;
	otherwise
		value = sscanf(value, '%s');
end

if nargout == 2
	tag = s(1:i_arg-1);
end