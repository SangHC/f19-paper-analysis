function [ RGB_F19_Combined ] = ComputeCombinedRGB( patientNumber, f19_rgb , f19_lung )
%Plots combined RGB

%% Get data size
[numrows , numcols , numslices ] = size(f19_lung);

%% Compute Center Slice
for slice = 1:numslices
    slicesum(slice) = sum(sum(f19_lung(:,:,slice)));
end
FirstSlice = min(find(slicesum>0));
LastSlice = max(find(slicesum>0));
NumSlices = LastSlice - FirstSlice + 1;

if rem(NumSlices,2) == 1 % odd number of slices
    CenterSlice = (FirstSlice + LastSlice)/2;
    
elseif rem(NumSlices,2) ==0 % even number slices
    PossibleCenterSlice1 = floor((FirstSlice + LastSlice)/2);
    PossibleCenterSlice2 =  ceil((FirstSlice + LastSlice)/2);
    if slicesum(PossibleCenterSlice1) > slicesum (PossibleCenterSlice2)
        CenterSlice = PossibleCenterSlice1;
    else
        CenterSlice = PossibleCenterSlice2;
    end
end

%% Put RGB info into 5 slices
RGB_F19_Combined(:,:,1,:) = f19_rgb(:,:,CenterSlice-3,:);
RGB_F19_Combined(:,:,2,:) = f19_rgb(:,:,CenterSlice-1,:);
RGB_F19_Combined(:,:,3,:) = f19_rgb(:,:,CenterSlice,:);
RGB_F19_Combined(:,:,4,:) = f19_rgb(:,:,CenterSlice+1,:);
RGB_F19_Combined(:,:,5,:) = f19_rgb(:,:,CenterSlice+3,:);

end

