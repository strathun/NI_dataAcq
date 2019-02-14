%% Demultiplex && Downsample
clear channelArray
numChannels = 8;
samplesPerChannel = 13;
skipper = numChannels * samplesPerChannel;
startIndex = 25;

nextChannel = 0;    % counter used to switch to next channel
for ii = 1:numChannels
    channelArray(ii,:) = data(startIndex+nextChannel:skipper:end-((skipper - startIndex) + 1));
    nextChannel = nextChannel + 8;
end

plot(channelArray(1,:))