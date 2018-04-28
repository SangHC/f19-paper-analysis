function [  ] = PlotUnventilatedMap( PatientNumber , UnventilatedMap )
%Plots Unventilated Map and saves results if indicated     plot_title = sprintf('Subject %i', patients(i));
%
figure();clf
subplot(4,4,1)
imshow(UnventilatedMap(:,:,2), [])
title(sprintf('Subject %i - Unventilated Map', PatientNumber))

subplot(4,4,2)
imshow(UnventilatedMap(:,:,3), [])
subplot(4,4,3)
imshow(UnventilatedMap(:,:,4), [])
subplot(4,4,4)
imshow(UnventilatedMap(:,:,5), [])
subplot(4,4,5)
imshow(UnventilatedMap(:,:,6), [])
subplot(4,4,6)
imshow(UnventilatedMap(:,:,7), [])
subplot(4,4,7)
imshow(UnventilatedMap(:,:,8), [])
subplot(4,4,8)
imshow(UnventilatedMap(:,:,9), [])
subplot(4,4,9)
imshow(UnventilatedMap(:,:,10), [])
subplot(4,4,10)
imshow(UnventilatedMap(:,:,11), [])
subplot(4,4,11)
imshow(UnventilatedMap(:,:,12), [])
subplot(4,4,12)
imshow(UnventilatedMap(:,:,13), [])
subplot(4,4,13)
imshow(UnventilatedMap(:,:,14), [])
subplot(4,4,14)
imshow(UnventilatedMap(:,:,15), [])
subplot(4,4,15)
imshow(UnventilatedMap(:,:,16), [])
subplot(4,4,16)
imshow(UnventilatedMap(:,:,17), [])


end

