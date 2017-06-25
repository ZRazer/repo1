function plotCloudsByIndex(VLPpoints, VLPsets, i1, i2)
%plotCloudsByIndex Plot Two Point Clouds by Index of VLPsets
%   Plots two point clouds identified by given index of VLPsets
%global VLPsets;

    cur_s_e_1 = VLPsets(i1,2:3);
    cur_s_e_2 = VLPsets(i2,2:3);
    s = cur_s_e_1(1);
    e = cur_s_e_1(2);
    s2 = cur_s_e_2(1);
    e2 = cur_s_e_2(2);
    plotTwoClouds(VLPpoints, s, e, '.k', s2, e2, '+r');
end