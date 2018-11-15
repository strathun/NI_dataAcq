function writeDatafun(src,event)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
%   Update this function to generate new filename.

A = [event.Data];

fileID = fopen('data.txt', 'a');
fprintf(fileID,'%5d\r\n',A);
fclose(fileID);

end

