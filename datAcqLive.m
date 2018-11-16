%number of fft samples/bin
fftBin = 500;

fileID = fopen('data.txt', 'w');
fprintf(fileID,'%5d\r\n','data');
fclose(fileID);

%scans for connected devices. 
devices = daq.getDevices;
s = daq.createSession('ni');

%Creates a channel for Voltage recording. Get device name from list above
addAnalogInputChannel(s,'cDAQ1Mod1',0,'Voltage');

%Sampling rate/duration
s.Rate = 1e6;
s.DurationInSeconds = 5;

lh = addlistener(s,'DataAvailable', @(src,event) plot(event.TimeStamps, event.Data));
llh = addlistener(s,'DataAvailable', @writeDatafun);

s.NotifyWhenDataAvailableExceeds = 50000;
s.startBackground();
s.wait()
delete(lh);
delete(llh);

% % use to view data
% load data.txt;
% data = data(5:end);
% [n,p] = size(data);
% t = 1:n;
% plot(t,data)

% %%
% L = (s.Rate)*(s.DurationInSeconds);
% 
% %Generate power spectrum for signal
% Y = fft(data);
% P2 = abs(Y/L);
% P1 = P2(1:(L/2)+1);
% P1(2:end-1) = 2*P1(2:end-1);
% f = (s.Rate)*(0:(L/2))/L;
% 
% %%
% figure
% semilogx(f,abs(P1)*1e6)
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
% xlim([0 s.Rate/2])
% ylim([1 20])