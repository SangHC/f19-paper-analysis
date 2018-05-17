function [P90data , meantop10data] = PlotF19Histogram( patientNumber, f19MIITData3D)
%plots histogram of f19 and gives mean/median values for top percentiles
%% Select all data inside lung for f19
f19_insidelung_MIIT_data = f19MIITData3D(find(f19MIITData3D>0));

%% Plot histogram
figure(4);clf
histogram(f19_insidelung_MIIT_data)
title(sprintf('Subject %i', patientNumber))

%% Get 95 percentile and mean of top 5% data
P90data = prctile(f19_insidelung_MIIT_data,90);
meantop10data = mean(f19_insidelung_MIIT_data(find(f19_insidelung_MIIT_data>P90data)));

% 
% %Save figure (optional)
% if SaveSixSegmentModelBool
%     FigureDirectory    = strcat('G:\2017-Glass\f19_fit_results\SixSegmentModel2\');  mkdir(FigureDirectory);
%     FigureName = strcat('SixSegments_Patient_',string(patientNumber));
%     FileName = char(strcat(FigureDirectory,FigureName,'.png'));
%     saveas(gcf,FileName)
% end


end

