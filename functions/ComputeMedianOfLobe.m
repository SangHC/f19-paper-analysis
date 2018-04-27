function [ median_lobe_value ] = ComputeMedianOfLobe( lobe_ventilated_3d )
% computes median of lobe for input 3d lobar data

%% Choose only lobe values within segmentation
lobevals_ventilated = lobe_ventilated_3d(lobe_ventilated_3d>0);
median_lobe_value = median(lobevals_ventilated);
  
end
