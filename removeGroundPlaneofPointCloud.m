function [ remainPtCloud, planeGroundPC, modelPlaneGround] = removeGroundPlaneofPointCloud(ptCloud, showPlots )
%removeGroundPlaneofPointCloud Removes Ground Plane of a Given Point Cloud
%   [ remainPtCloud, planeGroundPC, modelPlaneGround] = removeGroundPlaneofPointCloud(ptCloud, showPlots )
%   Removes Ground Plane of a Given Point Cloud. Remaining Point Cloud, 
%   Plane Point Cloud and Model of Ground Plane are output. 
%   If showPlots = 1 all point clouds are plotted also.


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
        title('Ground Plane');

        figure
        pcshow(remainPtCloud)
        title('Remaining Point Cloud');
    end

end



