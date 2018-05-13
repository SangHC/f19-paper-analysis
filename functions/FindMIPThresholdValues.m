function [ low_vent, mid_vent, high_vent ] = FindMIPThresholdValues( MIP )
%Determines low, medium, high ventilation threshold using MIP
% uses 1st and 18th slice of MIP which do not have f19 signal

%% Get background values from MIP
slice1  = MIP(:,:,1);  slice1  = slice1(:);
slice18 = MIP(:,:,18); slice18 = slice18(:);
background = [slice1;slice18]; background = background(:);

%% Compute background mean and std
bgd_mean = mean(background);
bgd_std  =  std(background);

%% Compute Ventilation Thresholds
low_vent  = bgd_mean +  3*bgd_std; % 3 stds
mid_vent  = bgd_mean +  6*bgd_std; % 6 stds
high_vent = bgd_mean + 10*bgd_std; % 10 stds

end