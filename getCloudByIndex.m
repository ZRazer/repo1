function ptCloud = getCloudByIndex(VLPpoints, VLPsets, index, showPlots)
%getCloudByIndex Get Point Cloud by Index of VLPsets
%   ptCloud = getCloudByIndex(VLPpoints, VLPsets, index, showPlots)
%   Get point cloud identified by given index of VLPsets. If showPlots = 1 
%   all point clouds are plotted also.

%global VLPsets;

    cur_s_e = VLPsets(index,2:3);
    startIndex = cur_s_e(1);
    endIndex = cur_s_e(2);
        
    ptCloud = pointCloud(VLPpoints(startIndex:endIndex,:));
    
    if showPlots==1
        figure;
        pcshow(ptCloud);
    end
end