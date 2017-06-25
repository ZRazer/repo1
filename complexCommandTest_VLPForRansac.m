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

N=3000000;
VLPpoints = zeros(N,3);
index = 1;

M = 50000;
X = zeros(M,1);
Y = zeros(M,1);
Z = zeros(M,1);

I = zeros(M,2);
index2 = 1;

K = 1000;
VLPsets = zeros(K,3);
VLPsetsIndex = 1;
VLPsetNumberOfPoints = 0;
quarterCounter = 0;
startI = 1;
endI = 1;

plotFlag = 1;

if  clientID>-1
    figure;
    title('Raw VLP 16 Point Cloud');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on;
    %hold on;
    while (1==1)
        
        connectionId=vrep.simxGetConnectionId(clientID);
        
        if connectionId>-1
            
            [res, retInt, retFloats, retStrings, retBuffer]=vrep.simxCallScriptFunction(clientID, 'velodyneVPL_16', vrep.sim_scripttype_childscript, 'getVelodyneData_function',[],[],[],[],vrep.simx_opmode_blocking);
            
            if res == 0
            
                A=retInt;
                I(index2,:) = A;
                index2 = index2 + 1;

                B=retFloats;
                D=length(B)/3-1;

                %[res2 retInts2 retFloats2 retStrings2 retBuffer2]=vrep.simxCallScriptFunction(clientID, 'velodyneVPL_16#0', vrep.sim_scripttype_childscript, 'getVelodyneData_function2',[],[],[],[],vrep.simx_opmode_blocking);
                %B2=retFloats2;
                %D2=length(B2)/3-1;

                %ugv point cloud
                for i=0:D
                    a=3*i+1;
                    b=3*i+2;
                    c=3*i+3;

                    X(i+1)=B(1,c);
                    Y(i+1)=B(1,a);
                    Z(i+1)=B(1,b);


    %                 X(i+1)=-B(1,b);
    %                 Y(i+1)=B(1,c);
    %                 Z(i+1)=-B(1,a);
                end

                quarterCounter = quarterCounter + 1;
                VLPsetNumberOfPoints = VLPsetNumberOfPoints + D + 1;

                VLPpoints(index:index+D,:)=[X(1:D+1) Y(1:D+1) Z(1:D+1)];
                index = index + D + 1;            

                if quarterCounter == 4
                    quarterCounter = 0;
                    endI = startI + VLPsetNumberOfPoints - 1;
                    VLPsets(VLPsetsIndex,:) = [VLPsetNumberOfPoints, startI, endI];

                    cur_s_e = VLPsets(VLPsetsIndex,2:3);
                    s = cur_s_e(1);
                    e = cur_s_e(2);
                    if plotFlag == 1
                        p = plot3(VLPpoints(s:e,1),VLPpoints(s:e,2),VLPpoints(s:e,3),'.k');
                        title('Raw VLP 16 Point Cloud');
                        xlabel('x');
                        ylabel('y');
                        zlabel('z');
                        grid on;                        
                        plotFlag = 0;
                    else
                        p.XData = VLPpoints(s:e,1);
                        p.YData = VLPpoints(s:e,2);
                        p.ZData = VLPpoints(s:e,3);
                    end
                    drawnow limitrate;

                    VLPsetsIndex = VLPsetsIndex + 1;
                    VLPsetNumberOfPoints = 0;
                    startI = endI + 1;

                end





    %             %uav point cloud
    %             B2=retFloats2;
    %             D2=length(B2)/3-1;
    %             for i2=0:D2
    %                 a2=3*i2+1;
    %                 b2=3*i2+2;
    %                 c2=3*i2+3;
    %                 X2(i2+1)=B2(1,a2);
    %                 Y2(i2+1)=-B2(1,c2);
    %                 Z2(i2+1)=B2(1,b2);
    %             end




                %plot3(X,Y,Z,'.b');

    %            plot3(X2,Y2,Z2,'.r');

                %drawnow limitrate;
            end
            
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

%% Remove Ground Plane

ptCloud = pointCloud(VLPpoints(1:index-1,:));
figure;
pcshow(ptCloud);

%RANSAC
maxDistance = 0.02;
referenceVector = [0,0,1];
maxAngularDistance = 5;
[model1,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
plane1 = select(ptCloud,inlierIndices);
remainPtCloud = select(ptCloud,outlierIndices);

figure
pcshow(plane1);
title('First Plane');

figure
pcshow(remainPtCloud)
title('Remaining Point Cloud');

%%


% Diff Point Clouds
% cur_s_e_1 = VLPsets(3,2:3);
% cur_s_e_2 = VLPsets(4,2:3);
% 
% VLPpointsDiff=VLPpoints(cur_s_e_1(1):cur_s_e_1(2),:) - VLPpoints(cur_s_e_2(1):cur_s_e_2(2),:);
% 
% plot3(VLPpointsDiff(:,1),VLPpointsDiff(:,2),VLPpointsDiff(:,3));

%% Plot Different Scans on top of each other (Visualize Point Cloud Differences)


%global VLPsets;
%global VLPpoints;
plotCloudsByIndex(VLPpoints, VLPsets, 1,4);


%% Voxel Grid Filtering

%ptCloudOut = pcdownsample(ptCloudIn,'gridAverage',gridStep) 
%returns a downsampled point cloud using a box grid filter. The gridStep input specifies the size of a 3-D box.

ptCloud = pointCloud(VLPpoints(startIndex:endIndex,:));

gridStep = 0.1;
ptCloudA = pcdownsample(ptCloud,'gridAverage',gridStep);

figure;
pcshow(ptCloudA);

%%
ptCloudOrg = getCloudByIndex(VLPpoints, VLPsets, 11, 0);

[ remainPtCloud, planeGroundPC, modelPlaneGround] = removeGroundPlaneofPointCloud(ptCloudOrg, 1 );

gridStep = 0.05;
ptCloudA = pcdownsample(remainPtCloud,'gridAverage',gridStep);

figure;
pcshow(ptCloudA);
title('Voxel Grid Filtered Point Cloud');



%% ICP Deneme

ptCloudOrg = getCloudByIndex(VLPpoints, VLPsets, 1, 1);
[ remainPtCloud, ~, ~] = removeGroundPlaneofPointCloud(ptCloudOrg, 0 );
gridStep = 0.05;
ptCloudFixed = pcdownsample(remainPtCloud,'gridAverage',gridStep);

ptCloudOrg2 = getCloudByIndex(VLPpoints, VLPsets, 53, 1);
[ remainPtCloud, ~, ~] = removeGroundPlaneofPointCloud(ptCloudOrg2, 0 );
gridStep = 0.05;
ptCloudMoving = pcdownsample(remainPtCloud,'gridAverage',gridStep);



tform = pcregrigid(ptCloudMoving,ptCloudFixed,'Extrapolate',true);
tform2 = invert(tform);
disp(tform2.T);


tform = pcregrigid(ptCloudMoving,ptCloudFixed, 'Verbose', true);
tform2 = invert(tform);
disp(tform2.T);

tform = pcregrigid(ptCloudMoving,ptCloudFixed, 'Metric', 'pointToPlane');
tform2 = invert(tform);
disp(tform2.T);

tform = pcregrigid(ptCloudMoving,ptCloudFixed, 'InlierRatio',0.7, 'Verbose', true);
tform2 = invert(tform);
disp(tform2.T);


%% Convert & Save to PCD Format of PCL

ptXYZCloud1 = getXYZCloudByIndex(VLPpoints, VLPsets, 1);
ptXYZCloud2 = getXYZCloudByIndex(VLPpoints, VLPsets, 2);
ptXYZCloud3 = getXYZCloudByIndex(VLPpoints, VLPsets, 3);
ptXYZCloud4 = getXYZCloudByIndex(VLPpoints, VLPsets, 4);
ptXYZCloud5 = getXYZCloudByIndex(VLPpoints, VLPsets, 5);

savepcd('ptXYZCloud1.pcd', ptXYZCloud1);
savepcd('ptXYZCloud2.pcd', ptXYZCloud2);
savepcd('ptXYZCloud3.pcd', ptXYZCloud3);
savepcd('ptXYZCloud4.pcd', ptXYZCloud4);
savepcd('ptXYZCloud5.pcd', ptXYZCloud5);

savepcd('ptXYZCloud1b.pcd', ptXYZCloud1, 'binary');
savepcd('ptXYZCloud2b.pcd', ptXYZCloud2, 'binary');
savepcd('ptXYZCloud3b.pcd', ptXYZCloud3, 'binary');
savepcd('ptXYZCloud4b.pcd', ptXYZCloud4, 'binary');
savepcd('ptXYZCloud5b.pcd', ptXYZCloud5, 'binary');

lspcd

