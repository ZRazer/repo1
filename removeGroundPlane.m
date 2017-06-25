function [ remainPtCloud, planeGroundPC, ptCloud ] = removeGroundPlane(VLPpoints, startIndex, endIndex, showPlots )
%removeGroundPlane Removes Ground Plane of a Given Point Cloud
%   [ remainPtCloud, planeGroundPC, ptCloud ] = removeGroundPlane(VLPpoints, startIndex, endIndex, showPlots )
%   Removes Ground Plane of a Given Point Cloud in XYZ format. Point Cloud
%   is selected by given start and end indexes. Remaining Point Cloud, 
%   Plane Point Cloud and Original XYZ Point are output in Point Cloud 
%   Format. If showPlots = 1 all point clouds are plotted also.


ptCloud = pointCloud(VLPpoints(startIndex:endIndex,:));

if showPlots==1
    figure;
    pcshow(ptCloud);
end

%RANSAC
maxDistance = 0.02;
referenceVector = [0,0,1];
maxAngularDistance = 5;
[modelPlaneGround,inlierIndices,outlierIndices] = pcfitplane(ptCloud,maxDistance,referenceVector,maxAngularDistance);
planeGroundPC = select(ptCloud,inlierIndices);
remainPtCloud = select(ptCloud,outlierIndices);

if showPlots == 1
    figure
    pcshow(planeGroundPC);
    title('First Plane');

    figure
    pcshow(remainPtCloud)
    title('Remaining Point Cloud');
end

end



