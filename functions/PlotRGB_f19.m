function [ RGB_F19_MATRIX UnventilatedMap MinimalVentMap ModerateVentMap HighVentMap ] = PlotRGB_f19( patientNumber, PlotRGBImageBool,SaveRGBImageBool,f19_image, background, low_vent, mid_vent, high_vent )
%Creates RGB matrix for f19 MIP and plots resulting rgb image

%% Create RGB Array for f19 MIP image using thresholding
% preallocate for speed
RGB_F19_MATRIX  = zeros(128,128,18,3,'uint8');
UnventilatedMap = zeros(128,128,18,'uint8');
MinimalVentMap  = zeros(128,128,18,'uint8');
ModerateVentMap = zeros(128,128,18,'uint8');
HighVentMap     = zeros(128,128,18,'uint8');

for slice=1:18
    for row = 1:128
        for col = 1:128
            if     (f19_image(row,col,slice)<background)
                % color grey
                RGB_F19_MATRIX(row,col,slice,1) = 185;
                RGB_F19_MATRIX(row,col,slice,2) = 185;
                RGB_F19_MATRIX(row,col,slice,3) = 185;
                
            elseif (f19_image(row,col,slice)>background && ...
                    f19_image(row,col,slice)<low_vent)
                % color black
                RGB_F19_MATRIX(row,col,slice,1) = 0;
                RGB_F19_MATRIX(row,col,slice,2) = 0;
                RGB_F19_MATRIX(row,col,slice,3) = 0;
                
                UnventilatedMap(row,col,slice) = 1;
                
            elseif (f19_image(row,col,slice)>low_vent   && ...
                    f19_image(row,col,slice)<mid_vent)
                % color red
                RGB_F19_MATRIX(row,col,slice,1) = 225;
                RGB_F19_MATRIX(row,col,slice,2) = 0;
                RGB_F19_MATRIX(row,col,slice,3) = 0;
                
                MinimalVentMap(row,col,slice) = 1;
                
            elseif (f19_image(row,col,slice)>mid_vent   && ...
                    f19_image(row,col,slice)<high_vent)
                % color yellow
                RGB_F19_MATRIX(row,col,slice,1) = 225;
                RGB_F19_MATRIX(row,col,slice,2) = 225;
                RGB_F19_MATRIX(row,col,slice,3) = 75;
                
                ModerateVentMap(row,col,slice) = 1;
                
            elseif (f19_image(row,col,slice)>high_vent)
                % color green
                RGB_F19_MATRIX(row,col,slice,1) = 0;
                RGB_F19_MATRIX(row,col,slice,2) = 152;
                RGB_F19_MATRIX(row,col,slice,3) = 51;
                
                HighVentMap(row,col,slice) = 1;
                
            end
        end
    end
end

% Plot RGB Image on Figure 2

if PlotRGBImageBool
    
    figure(2);clf
    
    subplot(4,4,1)
    imshow(squeeze(RGB_F19_MATRIX(:,:,2,:)))
    title(sprintf('Subject %i', patientNumber))
    subplot(4,4,2)
    imshow(squeeze(RGB_F19_MATRIX(:,:,3,:)))
    subplot(4,4,3)
    imshow(squeeze(RGB_F19_MATRIX(:,:,4,:)))
    subplot(4,4,4)
    imshow(squeeze(RGB_F19_MATRIX(:,:,5,:)))
    subplot(4,4,5)
    imshow(squeeze(RGB_F19_MATRIX(:,:,6,:)))
    subplot(4,4,6)
    imshow(squeeze(RGB_F19_MATRIX(:,:,7,:)))
    subplot(4,4,7)
    imshow(squeeze(RGB_F19_MATRIX(:,:,8,:)))
    subplot(4,4,8)
    imshow(squeeze(RGB_F19_MATRIX(:,:,9,:)))
    subplot(4,4,9)
    imshow(squeeze(RGB_F19_MATRIX(:,:,10,:)))
    subplot(4,4,10)
    imshow(squeeze(RGB_F19_MATRIX(:,:,11,:)))
    subplot(4,4,11)
    imshow(squeeze(RGB_F19_MATRIX(:,:,12,:)))
    subplot(4,4,12)
    imshow(squeeze(RGB_F19_MATRIX(:,:,13,:)))
    subplot(4,4,13)
    imshow(squeeze(RGB_F19_MATRIX(:,:,14,:)))
    subplot(4,4,14)
    imshow(squeeze(RGB_F19_MATRIX(:,:,15,:)))
    subplot(4,4,15)
    imshow(squeeze(RGB_F19_MATRIX(:,:,16,:)))
    subplot(4,4,16)
    imshow(squeeze(RGB_F19_MATRIX(:,:,17,:)))
    
    pause(0.1)
end

%% Save figure (optional)
if SaveRGBImageBool
    FigureDirectory    = strcat('.\outputs\RGB_f19\');  mkdir(FigureDirectory);
    FigureName = strcat('f19_RGB_Patient_',string(patientNumber));
    FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    saveas(gcf,FileName)
end

end

