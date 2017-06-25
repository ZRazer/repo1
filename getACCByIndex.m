function data = getACCByIndex(SensorData, index)
%getACCByIndex Get Accelerometer by Index
%   data = getACCByIndex(SensorData, index)
%   Get accelerometer data identified by given index.
        
    data = SensorData(index,1:3);

end