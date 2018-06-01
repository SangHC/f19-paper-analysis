function [  ] = PlotMIPImage( PatientNumber, SaveMIPImageBool, f19_lung , low_vent , high_vent )
% Plots MIP image inside of anatomic lung contour
% uses low_vent and high_vent thresholds to window

% Initialize Plot
figure(1);clf
plot_title = sprintf('Subject %i', PatientNumber);
window_f19 = [low_vent high_vent];

% Plot using subplot
subplot(4,4,1)
imshow(f19_lung(:,:,2), window_f19)
title(plot_title)

subplot(4,4,2)
imshow(f19_lung(:,:,3), window_f19)
subplot(4,4,3)
imshow(f19_lung(:,:,4), window_f19)
subplot(4,4,4)
imshow(f19_lung(:,:,5), window_f19)
subplot(4,4,5)
imshow(f19_lung(:,:,6), window_f19)
subplot(4,4,6)
imshow(f19_lung(:,:,7), window_f19)
subplot(4,4,7)
imshow(f19_lung(:,:,8), window_f19)
subplot(4,4,8)
imshow(f19_lung(:,:,9), window_f19)
subplot(4,4,9)
imshow(f19_lung(:,:,10), window_f19)
subplot(4,4,10)
imshow(f19_lung(:,:,11), window_f19)
subplot(4,4,11)
imshow(f19_lung(:,:,12), window_f19)
subplot(4,4,12)
imshow(f19_lung(:,:,13), window_f19)
subplot(4,4,13)
imshow(f19_lung(:,:,14), window_f19)
subplot(4,4,14)
imshow(f19_lung(:,:,15), window_f19)
subplot(4,4,15)
imshow(f19_lung(:,:,16), window_f19)
subplot(4,4,16)
imshow(f19_lung(:,:,17), window_f19)

% pause to visualize
pause(0.2)

%% Save figure
if SaveMIPImageBool
    FigureDirectory    = strcat('.\outputs\MIP_f19\');  mkdir(FigureDirectory);
    FigureName = strcat('MIP_Patient_',string(PatientNumber));
    FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    saveas(gcf,FileName)
end

end

