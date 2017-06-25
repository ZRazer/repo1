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
    while (1==1)
        
        connectionId=vrep.simxGetConnectionId(clientID);
        
        if connectionId>-1
            
            [res retInt retFloats retStrings retBuffer]=vrep.simxCallScriptFunction(clientID, 'velodyneVPL_16', vrep.sim_scripttype_childscript, 'getVelodyneData_function',[],[],[],[],vrep.simx_opmode_blocking);
            B=retFloats;
            D=length(B)/3-1;
            [res2 retInts2 retFloats2 retStrings2 retBuffer2]=vrep.simxCallScriptFunction(clientID, 'velodyneVPL_16#0', vrep.sim_scripttype_childscript, 'getVelodyneData_function2',[],[],[],[],vrep.simx_opmode_blocking);
            B2=retFloats2;
            D2=length(B2)/3-1;
            %ugv point cloud
            for i=0:D
                a=3*i+1;
                b=3*i+2;
                c=3*i+3;
                X(i+1)=B(1,a);
                Y(i+1)=B(1,b);
                Z(i+1)=-B(1,c);
            end
            %uav point cloud
            B2=retFloats2;
            D2=length(B2)/3-1;
            for i2=0:D2
                a2=3*i2+1;
                b2=3*i2+2;
                c2=3*i2+3;
                X2(i2+1)=B2(1,a2);
                Y2(i2+1)=-B2(1,c2);
                Z2(i2+1)=B2(1,b2);
            end
            plot3(X,Y,Z,'.b');
            
            plot3(X2,Y2,Z2,'.r');
            
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
