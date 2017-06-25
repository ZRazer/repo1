function [ gpsDiff ] = GPS_Diff(Sensor, lastIndex, firstIndex, display )
%GPS_Diff Get GPS Position Difference of two indexes
%   [ gpsDiff ] = GPS_Diff(Sensor, lastIndex, firstIndex, display )
%   Get GPS Position Difference of two indexes...
%   If display = 1 result is printed.

    gpsDiff = getGPSByIndex(Sensor,lastIndex)-getGPSByIndex(Sensor,firstIndex);

    if display
        disp(['GPS Diff of (' num2str(lastIndex) ',' num2str(firstIndex) ') (X,Y,Z): [' num2str(gpsDiff) ']']);
    end
    
end

