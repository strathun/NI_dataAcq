function writeDatafun(src,event)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
A = [event.Data];

fileID = fopen('data.txt', 'a');
fprintf(fileID,'%5d\r\n',A);
fclose(fileID);

end

