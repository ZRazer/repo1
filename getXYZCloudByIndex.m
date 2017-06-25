function ptXYZCloud = getXYZCloudByIndex(VLPpoints, VLPsets, index)
%getXYZCloudByIndex Get XYZ Point Cloud by Index of VLPsets
%   ptXYZCloud = getXYZCloudByIndex(VLPpoints, VLPsets, index)
%   Get XYZ point cloud identified by given index of VLPsets. 

%global VLPsets;

    cur_s_e = VLPsets(index,2:3);
    startIndex = cur_s_e(1);
    endIndex = cur_s_e(2);
        
    ptXYZCloud = (VLPpoints(startIndex:endIndex,:))';
    
end