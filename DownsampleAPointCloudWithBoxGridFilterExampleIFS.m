%% Downsample Point Cloud Using Box Grid Filter
% 
%%
% Read a point cloud.

% Copyright 2015 The MathWorks, Inc.

ptCloud = pcread('teapot.ply');
pcshow(ptCloud);
title('Original Point Cloud');

%%
% Set the 3-D resolution to be (0.1 x 0.1 x 0.1).
gridStep = 0.1;
ptCloudA = pcdownsample(ptCloud,'gridAverage',gridStep); 
%%
% Visualize the downsampled data.
figure;
pcshow(ptCloudA);
title('Point Cloud Downsampled by gridAverage');

%%
% Compare the point cloud to data that is downsampled using a fixed step size.
stepSize = floor(ptCloud.Count/ptCloudA.Count);
indices = 1:stepSize:ptCloud.Count;
ptCloudB = select(ptCloud, indices);

figure;
pcshow(ptCloudB);
title('Point Cloud Downsampled by fixed step size');

%%
percentage = 0.15;
ptCloudC = pcdownsample(ptCloud,'random',percentage);

figure;
pcshow(ptCloudC);
title('Point Cloud Downsampled by random');

%%
maxNumPoints = 10;
ptCloudD = pcdownsample(ptCloud,'nonuniformGridSample',maxNumPoints);

figure;
pcshow(ptCloudD);
title('Point Cloud Downsampled by nonuniformGridSample');
