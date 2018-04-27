function [ segmentation_moved ] = Stretch_F19_ApexBase( segmentation_moving, segmentation_fixed )
%Computes apex base measurement from roi of function and pixel size
%   segmentation = 3d matrix of image binary information
%   pixel_size is in mm

%% Get dimensions of input segmentations
segmentation_moving_dimensions = size(segmentation_moving);
segmentation_fixed_dimensions = size(segmentation_fixed);

%% Loop to find max of each row
for row = 1:segmentation_moving_dimensions(1)
    moving_row_maximums(row) = max(max(segmentation_moving(row,:,:)));
end

for row = 1:segmentation_fixed_dimensions(1)
    fixed_row_maximums(row) = max(max(segmentation_fixed(row,:,:)));
end

%% Stretch moving image to get output
StretchRatio_ApexBase = sum(fixed_row_maximums(:))/sum(moving_row_maximums(:));
NewNumberOfRows = round(segmentation_moving_dimensions(1)*StretchRatio_ApexBase);
for slice = 1:segmentation_moving_dimensions(3)
    segmentation_moved(:,:,slice) = imresize(squeeze(segmentation_moving(:,:,slice)),[NewNumberOfRows segmentation_moving_dimensions(2)]);
end

%% Pad moving image to 192
segmentation_moved((NewNumberOfRows+1):192,:,:) = 0;

end