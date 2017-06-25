function data = getGPSByIndex(SensorData, index)
%getGPSByIndex Get Gps Data by Index
%   data = getGPSByIndex(SensorData, index)
%   Get GPS data identified by given index.
        
    data = SensorData(index,7:9);

end