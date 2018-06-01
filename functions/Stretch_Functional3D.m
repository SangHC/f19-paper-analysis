function [ moving_stretched ApexBaseStretchRatio LeftRightStretchRatio ] = Stretch_Functional3D( moving, fixed )
%Stretches moving mask image to correct respiratory effort in:
% 1) apex base direction 
% 2) left right direction

%% Get dimensions of input segmentation
moving_dimensions = size(moving);
fixed_dimensions  = size(fixed);

%% Compute Apex-base Measurements
% moving - okay to sum b/c assume no gaps
for row = 1:moving_dimensions(1)
    moving_row_maximums(row) = max(max(moving(row,:,:)));
end
Moving_ApexBaseMeasurement_pixels = sum(moving_row_maximums(:));
% fixed
for row = 1:fixed_dimensions(1)
    fixed_row_maximums(row) = max(max(fixed(row,:,:)));
end
Fixed_ApexBaseMeasurement_pixels = sum(fixed_row_maximums(:));

%% Compute Left-Right Measurements
% moving
for col = 1:moving_dimensions(2)
    moving_col_maximums(col) = max(max(moving(:,col,:)));
end
Moving_LeftRightMeasurement_pixels = find(moving_col_maximums>0, 1, 'last' ) - find(moving_col_maximums>0, 1 );

% fixed
for col = 1:fixed_dimensions(2)
    fixed_col_maximums(col) = max(max(fixed(:,col,:)));
end
Fixed_LeftRightMeasurement_pixels = find(fixed_col_maximums>0, 1, 'last' ) - find(fixed_col_maximums>0, 1 );

%% Stretch moving by ratio of measurements
% ApexBase
ApexBaseStretchRatio = Fixed_ApexBaseMeasurement_pixels/Moving_ApexBaseMeasurement_pixels - 0.1;
NumberRows_stretched = round(moving_dimensions(1)*ApexBaseStretchRatio);
%LeftRight
LeftRightStretchRatio = Fixed_LeftRightMeasurement_pixels/Moving_LeftRightMeasurement_pixels;
NumberCols_stretched = round(moving_dimensions(2)*LeftRightStretchRatio);
%Stretch Image
moving_stretched = imresize(moving, [ NumberRows_stretched    NumberCols_stretched ]);

end

