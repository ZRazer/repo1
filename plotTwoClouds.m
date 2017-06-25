function p = plotTwoClouds(VLPpoints, s, e, fmt, s2, e2, fmt2)
%plotTwoClouds plot Two Point Clouds 
%   plots two point clouds identified by given start & end indexes from
%   VLPpoints dataset
%global VLPpoints;

    p = plot3(VLPpoints(s:e,1),VLPpoints(s:e,2),VLPpoints(s:e,3),fmt, ...
        VLPpoints(s2:e2,1),VLPpoints(s2:e2,2),VLPpoints(s2:e2,3),fmt2, 'Marker','+', 'MarkerSize', 2);
    %p = plot3(VLPpoints(s:e,1),VLPpoints(s:e,2),VLPpoints(s:e,3),fmt, 'Marker','.', 'MarkerSize', 2, ...
    %    VLPpoints(s2:e2,1),VLPpoints(s2:e2,2),VLPpoints(s2:e2,3),fmt2, 'Marker','+', 'MarkerSize', 2);
    title('Two Consecutive Point Clouds');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    grid on;  
    
end