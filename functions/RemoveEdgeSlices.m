function [ OUTPUT ] = RemoveEdgeSlices( INPUT_IMAGE )
%removes first and last slices that contain information for mxnx18
%image

OUTPUT = INPUT_IMAGE;

for slice = 1:size(INPUT_IMAGE,3)
    if sum(sum(INPUT_IMAGE(:,:,slice))) > 0
        OUTPUT(:,:,slice) = 0;
        break
    end
end

for slice = 1:size(INPUT_IMAGE,3)
    if sum(sum(INPUT_IMAGE(:,:,18-slice))) > 0
        OUTPUT(:,:,18-slice) = 0;
        break
    end
end


end

