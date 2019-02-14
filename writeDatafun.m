function writeDatafun(src,event,fileName)
%writeDatafun(src,event)
%   takes event and writes data to txt file

A = [event.Data];

% Appends most recent data to previously generated text file
fileID = fopen(fileName, 'a');
fprintf(fileID,'%5d\r\n',A);
fclose(fileID);

end

