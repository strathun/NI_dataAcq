%% datAqTotal.m 
% Connects to NI DAQ device and records time domain data for specified data
% rate and duration. Graphs data with significant delay.
% This is the initial script in this suite. Calls writeDatafun.m

%__________________User_Defined_Parameters________________________________%
sampleRate = 1e6;      % sets sampling rate
sampleDur  = 00.10;    % sets sampling duration (s)
frameSize  = 00.01;    % time in (s) per plot in live view
saveFileNote  = 'testingNewHardware';  % String for filename
%_________________________________________________________________________%

datestamp = datestr(date,29);
C = clock;
timestamp = sprintf('%02dhr_%02dmin_%02.0fsec',C(4),C(5),C(6));
fileName = sprintf('%s_%s_%s',datestamp,timestamp,saveFileNote);

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
% data, and one that writies data to txt file in small chunks. 
lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
llh = addlistener(s,'DataAvailable', @(src,event)obj.writeDatafun(src,event,fileName));

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
ylim([-.3 .3]);
