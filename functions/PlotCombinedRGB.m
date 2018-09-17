function [ ] = PlotCombinedRGB( patients, combined_RGB , VDP )
% Plots combined RGB
% 5d matrix (rows, cols, slices, rgb, pnum)

%% Get data size
[numrows , numcols , numslices, rgbsize, numsubjects ] = size(combined_RGB);

%% Plot Results in a loop
figure(5);clf

for subject = 1:numsubjects
    
    subplot_tight(numsubjects,5,subject*5 - 4)
    imshow(squeeze(combined_RGB(:,:,1,:,subject))) 
    subplot_tight(numsubjects,5,subject*5 - 3)
    imshow(squeeze(combined_RGB(:,:,2,:,subject)))
    subplot_tight(numsubjects,5,subject*5 - 2)
    imshow(squeeze(combined_RGB(:,:,3,:,subject)))
    title(sprintf('Subject %i - VDP %0.1f', patients(subject),VDP(subject)))
    subplot_tight(numsubjects,5,subject*5 - 1)
    imshow(squeeze(combined_RGB(:,:,4,:,subject)))
    subplot_tight(numsubjects,5,subject*5 - 0)
    imshow(squeeze(combined_RGB(:,:,5,:,subject)))

end

end

