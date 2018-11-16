%% datAqTotal.m 
% Connects to NI DAQ device and records time domain data for specified data
% rate and duration. Graphs data with significant delay.
% This is the initial script in this suite. Will run datAcqLive.m which runs
% writeData.m

% %scans for connected devices. 
% devices = daq.getDevices;
% s = daq.createSession('ni');
% 
% %Creates a channel for Voltage recording. Get device name from list above
% addAnalogInputChannel(s,'cDAQ1Mod1',0,'Voltage');
% 
% %Sampling rate/duration
% s.Rate = 2000;
% s.DurationInSeconds = 30;

% L = (s.Rate)*(s.DurationInSeconds);

datAcqLive

[data,time] = s.startForeground;

figure
plot(time, data)
xlabel('Time (s)')
ylabel('Voltage')
ylim([-.3 .3]);
%Generate power spectrum for signal
% Y = fft(data);
% P2 = abs(Y/L);
% P1 = P2(1:(L/2)+1);
% P1(2:end-1) = 2*P1(2:end-1);
% 
% figure
% plot(f,P1)
% xlabel('f (Hz)')
% ylabel('|P1(f)|')