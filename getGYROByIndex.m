function data = getGYROByIndex(SensorData, index)
%getGYROByIndex Get Gyro Data by Index
%   data = getGYROByIndex(SensorData, index)
%   Get gyro data identified by given index.
        
    data = SensorData(index,4:6);

end