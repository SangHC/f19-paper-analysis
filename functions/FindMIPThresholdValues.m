function [ low_vent, mid_vent, high_vent, MaxVentilation ] = FindMIPThresholdValues( MIP , f19_lung)
%Determines low, medium, high ventilation threshold using MIP
% uses 1st and 18th slice of MIP which do not have f19 signal
% MIP = entire MIP image
% f19_lung = MIP image with outside lung set to value of 0

%% Get background values from MIP
slice1  = MIP(:,:,1);  slice1  = slice1(:);
slice18 = MIP(:,:,18); slice18 = slice18(:);
background = [slice1;slice18]; background = background(:);

%% Compute background mean and std
bgd_mean = mean(background);
bgd_std  =  std(background);

%% Compute Ventilation Thresholds using bgd mean+std
low_vent  = bgd_mean +  3*bgd_std; % 3 stds
mid_vent  = bgd_mean +  6*bgd_std; % 6 stds
high_vent = bgd_mean + 10*bgd_std; % 10 stds

%% Compute Ventilation Thresholds using percent of max ventilation
insidelungMIITvals = f19_lung(find(f19_lung>0));
MaxVentilation     = prctile(insidelungMIITvals,90);

low_vent  = bgd_mean +  0.1 *(MaxVentilation-bgd_mean); % 10% of max ventilation
mid_vent  = bgd_mean +  0.3 *(MaxVentilation-bgd_mean); % 30% of max ventilation
high_vent = bgd_mean +  0.5 *(MaxVentilation-bgd_mean); % 50% of max ventilation

end