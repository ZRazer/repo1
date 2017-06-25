% Copyright 2006-2016 Coppelia Robotics GmbH. All rights reserved.
% marc@coppeliarobotics.com
% www.coppeliarobotics.com
%
% -------------------------------------------------------------------
% THIS FILE IS DISTRIBUTED "AS IS", WITHOUT ANY EXPRESS OR IMPLIED
% WARRANTY. THE USER WILL USE IT AT HIS/HER OWN RISK. THE ORIGINAL
% AUTHORS AND COPPELIA ROBOTICS GMBH WILL NOT BE LIABLE FOR DATA LOSS,
% DAMAGES, LOSS OF PROFITS OR ANY OTHER KIND OF LOSS WHILE USING OR
% MISUSING THIS SOFTWARE.
%
% You are free to use/modify/distribute this file for whatever purpose!
% -------------------------------------------------------------------
%
% This file was automatically created for V-REP release V3.3.2 on August 29th 2016

% This example illustrates how to execute complex commands from
% a remote API client. You can also use a similar construct for
% commands that are not directly supported by the remote API.
%
% Load the demo scene 'remoteApiCommandServerExample.ttt' in V-REP, then
% start the simulation and run this program.
%
% IMPORTANT: for each successful call to simxStart, there
% should be a corresponding call to simxFinish at the end!

%function complexCommandTest()
clc, clear
disp('Program started');
% vrep=remApi('remoteApi','extApi.h'); % using the header (requires a compiler)
vrep=remApi('remoteApi'); % using the prototype file (remoteApiProto.m)
vrep.simxFinish(-1); % just in case, close all opened connections
clientID=vrep.simxStart('127.0.0.1',19999,true,true,5000,5);

if  clientID>-1
    figure;
    hold on;
    
    [errorCode,handle]=vrep.simxGetObjectHandle(clientID,'Quadricopter_target',vrep.simx_opmode_oneshot);
    if errorCode == vrep.simx_return_ok 
        [errorcode]=vrep.simxSetObjectPosition(clientID,handle,-1,[0.7 0.5 1.5],vrep.simx_opmode_oneshot);
    end
    
    N = 1000;
    count = 0;
    gps_data_arr = zeros(N, 3);
    
    %First Call to Get Streaming Data of GSP should be in streaming mode
    [returnCode, GPS_pos]=vrep.simxGetStringSignal(clientID,'gpsPosSig', vrep.simx_opmode_streaming); %simx_opmode_buffer 
    if returnCode == 0
        count = count + 1;

        [GPS_pos_arr]=vrep.simxUnpackFloats(GPS_pos);

        gps_data_arr(count,:) = GPS_pos_arr;

        plot3(GPS_pos_arr(1),GPS_pos_arr(2),GPS_pos_arr(3),'.b');
    end
                
    while (1==1)
        
        connectionId=vrep.simxGetConnectionId(clientID);
        
        if connectionId>-1
            
%             [number returnCode,number signalValue]=simxGetFloatSignal(number clientID,string signalName,number operationMode)
%             Matlab parameters	
%             clientID: the client ID. refer to simxStart.
%             signalName: name of the signal
%             operationMode: a remote API function operation mode. Recommended operation modes for this function are simx_opmode_streaming (the first call) and simx_opmode_buffer (the following calls)
             
%             [returnCode, GPS_pos_X] = vrep.simxGetFloatSignal(clientID,'gpsX', vrep.simx_opmode_streaming);
%             [returnCode, GPS_pos_Y] = vrep.simxGetFloatSignal(clientID,'gpsY', vrep.simx_opmode_streaming);
%             [returnCode, GPS_pos_Z] = vrep.simxGetFloatSignal(clientID,'gpsZ', vrep.simx_opmode_streaming);
%             plot3(GPS_pos_X,GPS_pos_Y,GPS_pos_Z,'.b');
            
            %[number returnCode,string signalValue]=simxGetStringSignal(number clientID,string signalName,number operationMode);
            [returnCode, GPS_pos]=vrep.simxGetStringSignal(clientID,'gpsPosSig', vrep.simx_opmode_buffer);
             
            %[array floatValues]=simxUnpackFloats(string packedData);
            if returnCode == vrep.simx_return_ok 
                count = count + 1;
                
                [GPS_pos_arr]=vrep.simxUnpackFloats(GPS_pos);
                
                gps_data_arr(count,:) = GPS_pos_arr;
            
                plot3(GPS_pos_arr(1),GPS_pos_arr(2),GPS_pos_arr(3),'.b');
                                
                if count == 2500
                    [errorcode]=vrep.simxSetObjectPosition(clientID,handle,-1,[-0.7 -0.5 1.5],vrep.simx_opmode_oneshot);
                end

                if count == 5000
                    [errorcode]=vrep.simxSetObjectPosition(clientID,handle,-1,[1.1 -0.2 1.5],vrep.simx_opmode_oneshot);
                end

                
            end
            
            %plot3(X2,Y2,Z2,'.r');
            
            drawnow limitrate;
            
        else
            disp('Simulation Ended on remote API server. Exiting...')
            break;
        end
    end
else
    disp('Failed connecting to remote API server')
    %vrep.simxFinish(clientID);
end


%end
% Now close the connection to V-REP:

vrep.simxFinish(clientID);

vrep.delete(); % call the destructor!

disp('Program ended');
%end
