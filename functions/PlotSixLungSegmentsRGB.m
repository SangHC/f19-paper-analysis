function [ ] = PlotSixLungSegmentsRGB( patientNumber, SaveSixSegmentModelBool, UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight)
%Creates RGB matrix for f19 MIP and plots resulting rgb image

%% Create RGB Array for Six Segments
% preallocate for speed
RGB_Six_Segments  = zeros(128,128,18,3,'uint8');

for slice=1:18
    for row = 1:128
        for col = 1:128
            if     (UpperLeft(row,col,slice)>0)
                % color yellow
                RGB_Six_Segments(row,col,slice,1) = 255;
                RGB_Six_Segments(row,col,slice,2) = 255;
                RGB_Six_Segments(row,col,slice,3) = 153;
                
            elseif (MiddleLeft(row,col,slice)>0)
                % color black
                RGB_Six_Segments(row,col,slice,1) = 0;
                RGB_Six_Segments(row,col,slice,2) = 0;
                RGB_Six_Segments(row,col,slice,3) = 0;
                                
            elseif (LowerLeft(row,col,slice)>0)
                % color red
                RGB_Six_Segments(row,col,slice,1) = 225;
                RGB_Six_Segments(row,col,slice,2) = 0;
                RGB_Six_Segments(row,col,slice,3) = 0;
                              
            elseif (UpperRight(row,col,slice)>0)
                % color green
                RGB_Six_Segments(row,col,slice,1) = 0;
                RGB_Six_Segments(row,col,slice,2) = 153;
                RGB_Six_Segments(row,col,slice,3) = 204;
                
            elseif (MiddleRight(row,col,slice)>0)
                % color lime
                RGB_Six_Segments(row,col,slice,1) = 191;
                RGB_Six_Segments(row,col,slice,2) = 255;
                RGB_Six_Segments(row,col,slice,3) = 0;
                                
            elseif (LowerRight(row,col,slice)>0)
                % color orange
                RGB_Six_Segments(row,col,slice,1) = 255;
                RGB_Six_Segments(row,col,slice,2) = 127;
                RGB_Six_Segments(row,col,slice,3) = 80;
                
            else
                % color grey
                RGB_Six_Segments(row,col,slice,1) = 185;
                RGB_Six_Segments(row,col,slice,2) = 185;
                RGB_Six_Segments(row,col,slice,3) = 185;
                
            end
        end
    end
end

% Plot RGB Image
figure(3);clf

subplot(4,4,1)
imshow(squeeze(RGB_Six_Segments(:,:,2,:)))
title(sprintf('Subject %i', patientNumber))
subplot(4,4,2)
imshow(squeeze(RGB_Six_Segments(:,:,3,:)))
subplot(4,4,3)
imshow(squeeze(RGB_Six_Segments(:,:,4,:)))
subplot(4,4,4)
imshow(squeeze(RGB_Six_Segments(:,:,5,:)))
subplot(4,4,5)
imshow(squeeze(RGB_Six_Segments(:,:,6,:)))
subplot(4,4,6)
imshow(squeeze(RGB_Six_Segments(:,:,7,:)))
subplot(4,4,7)
imshow(squeeze(RGB_Six_Segments(:,:,8,:)))
subplot(4,4,8)
imshow(squeeze(RGB_Six_Segments(:,:,9,:)))
subplot(4,4,9)
imshow(squeeze(RGB_Six_Segments(:,:,10,:)))
subplot(4,4,10)
imshow(squeeze(RGB_Six_Segments(:,:,11,:)))
subplot(4,4,11)
imshow(squeeze(RGB_Six_Segments(:,:,12,:)))
subplot(4,4,12)
imshow(squeeze(RGB_Six_Segments(:,:,13,:)))
subplot(4,4,13)
imshow(squeeze(RGB_Six_Segments(:,:,14,:)))
subplot(4,4,14)
imshow(squeeze(RGB_Six_Segments(:,:,15,:)))
subplot(4,4,15)
imshow(squeeze(RGB_Six_Segments(:,:,16,:)))
subplot(4,4,16)
imshow(squeeze(RGB_Six_Segments(:,:,17,:)))

pause(0.2)

%Save figure (optional)
if SaveSixSegmentModelBool
    FigureDirectory    = strcat('G:\2017-Glass\f19_fit_results\SixSegmentModel2\');  mkdir(FigureDirectory);
    FigureName = strcat('SixSegments_Patient_',string(patientNumber));
    FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    saveas(gcf,FileName)
end


end

