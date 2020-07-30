%% datAcqTotal.m 
% Connects to NI DAQ device and records time domain data for specified data
% rate and duration. Graphs data with significant delay.
% This is the initial script in this suite. Calls writeDatafun.m
% datAcqLive should not be used... I don't think...
% Hardware required:
%   Noise headstage
%   Noise daughterboard
clear
close all
%__________________User_Defined_Parameters________________________________%
sampleRate = 20e3;      % sets sampling rate
sampleDur  = 01.00;    % sets sampling duration (s)
frameSize  = 00.1;    % time in (s) per plot in live view
saveFileNote  = 'HS_atInput_3kHz_4mVpp';  % String for filename
%_________________________________________________________________________%

datestamp = datestr(date,29);
C = clock;
timestamp = sprintf('%02dhr_%02dmin_%02.0fsec',C(4),C(5),C(6));
sampleInfo = sprintf('%0.3gkSs_%02ds', sampleRate, sampleDur );
fileName = sprintf('%s_%s_%s_%s',...
                   datestamp, ...
                   timestamp, ...
                   sampleInfo, ...
                   saveFileNote);

fileID = fopen(fileName, 'w');
fprintf(fileID,'%5d\r\n','data');
fclose(fileID);

%scans for connected devices. 
devices = daq.getDevices;
s = daq.createSession('ni');

%Creates a channel for Voltage recording. Get device name from list above
addAnalogInputChannel(s,'cDAQ1Mod1',0,'Voltage');

% Sampling rate/duration
s.Rate = sampleRate;
s.DurationInSeconds = sampleDur;

% Uses two listeners. One that plots data to give a rough live stream of
% data, and one that writes data to txt file in small chunks. 
lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
llh = addlistener(s,'DataAvailable', @(src,event) writeDatafun(src,event,fileName));

s.NotifyWhenDataAvailableExceeds = sampleRate * frameSize;
s.startBackground();
s.wait()
delete(lh);
delete(llh);

[data,time] = s.startForeground;

figure
plot(time, data)
xlabel('Time (s)')
ylabel('Voltage')
