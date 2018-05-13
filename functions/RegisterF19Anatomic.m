%% load images
clear;clc;
home = pwd;

% choose patient
all = [2;3;4;5;7;8;9;10;12;13;14;15;16;17;18;19;20;24;25;26;28;29;30;31;32;33;34;35;37;39;40];

normals = [2;3;4;5;15;16;17;19;26;31;37;39;40];
mild = [9;13;18;20;24;25;28;29;30;32;33;35];
moderate = [7;8;10;12;14;34];

% choose set
patients = all;
for i = 1:length(patients)
    
    % load ventilaion
    cd('G:\2017-Glass\mim\f19_ventilation_segmentations')
    %filename = strcat('0509-015','.mat');
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename);
    fixed = imresize(roi,[128,128]); % f19 is moving
    
    % load anatomical
    cd('G:\2017-Glass\mim\inspiration_anatomic_segmentations')
    %filename = strcat('0509-015','.mat');
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename)
    moving = imresize(inspiration_ROI, [128,128]); % anat is fixed
    moving(:,:,16:18) = 0; % make fixed the same size as moving functional
    
    % back to home directory
    cd(home)
    
    %     % view images
    %     figure(1);clf
    %     subplot(4,4,1)
    %     imshowpair(fixed(:,:,2), moving(:,:,2),'Scaling','joint');
    %     subplot(4,4,2)
    %     imshowpair(fixed(:,:,3), moving(:,:,3),'Scaling','joint');
    %     subplot(4,4,3)
    %     imshowpair(fixed(:,:,4), moving(:,:,4),'Scaling','joint');
    %     subplot(4,4,4)
    %     imshowpair(fixed(:,:,5), moving(:,:,5),'Scaling','joint');
    %     subplot(4,4,5)
    %     imshowpair(fixed(:,:,6), moving(:,:,6),'Scaling','joint');
    %     subplot(4,4,6)
    %     imshowpair(fixed(:,:,7), moving(:,:,7),'Scaling','joint');
    %     subplot(4,4,7)
    %     imshowpair(fixed(:,:,8), moving(:,:,8),'Scaling','joint');
    %     subplot(4,4,8)
    %     imshowpair(fixed(:,:,9), moving(:,:,9),'Scaling','joint');
    %     subplot(4,4,9)
    %     imshowpair(fixed(:,:,10), moving(:,:,10),'Scaling','joint');
    %     subplot(4,4,10)
    %     imshowpair(fixed(:,:,11), moving(:,:,11),'Scaling','joint');
    %     subplot(4,4,11)
    %     imshowpair(fixed(:,:,12), moving(:,:,12),'Scaling','joint');
    %     subplot(4,4,12)
    %     imshowpair(fixed(:,:,13), moving(:,:,13),'Scaling','joint');
    %     subplot(4,4,13)
    %     imshowpair(fixed(:,:,14), moving(:,:,14),'Scaling','joint');
    %     subplot(4,4,14)
    %     imshowpair(fixed(:,:,15), moving(:,:,15),'Scaling','joint');
    %     subplot(4,4,15)
    %     imshowpair(fixed(:,:,16), moving(:,:,16),'Scaling','joint');
    %     subplot(4,4,16)
    %     imshowpair(fixed(:,:,17), moving(:,:,17),'Scaling','joint');
    
    %% Stretch moving to match respiratory effort of fixed
    moving = Stretch_Functional3D(moving,fixed);
    
    %% Set up registration
    [optimizer, metric] = imregconfig('monomodal');
    MOVING_transformed = imregister(uint8(moving), uint8(fixed), 'translation', optimizer, metric);
    
    %% Remove end slices from registered anatomic outline
    MOVING_transformed = RemoveEdgeSlices(MOVING_transformed);
    
    %     %% Plot Registered Results
    %     figure(2);clf
    %     plot_title = sprintf('Subject %i', patients(i));
    %
    %     subplot(4,4,1)
    %     imshowpair(fixed(:,:,2), MOVING_transformed(:,:,2),'Scaling','joint');
    %     title(plot_title)
    %     subplot(4,4,2)
    %     imshowpair(fixed(:,:,3), MOVING_transformed(:,:,3),'Scaling','joint');
    %     subplot(4,4,3)
    %     imshowpair(fixed(:,:,4), MOVING_transformed(:,:,4),'Scaling','joint');
    %     subplot(4,4,4)
    %     imshowpair(fixed(:,:,5), MOVING_transformed(:,:,5),'Scaling','joint');
    %     subplot(4,4,5)
    %     imshowpair(fixed(:,:,6), MOVING_transformed(:,:,6),'Scaling','joint');
    %     subplot(4,4,6)
    %     imshowpair(fixed(:,:,7), MOVING_transformed(:,:,7),'Scaling','joint');
    %     subplot(4,4,7)
    %     imshowpair(fixed(:,:,8), MOVING_transformed(:,:,8),'Scaling','joint');
    %     subplot(4,4,8)
    %     imshowpair(fixed(:,:,9), MOVING_transformed(:,:,9),'Scaling','joint');
    %     subplot(4,4,9)
    %     imshowpair(fixed(:,:,10), MOVING_transformed(:,:,10),'Scaling','joint');
    %     subplot(4,4,10)
    %     imshowpair(fixed(:,:,11), MOVING_transformed(:,:,11),'Scaling','joint');
    %     subplot(4,4,11)
    %     imshowpair(fixed(:,:,12), MOVING_transformed(:,:,12),'Scaling','joint');
    %     subplot(4,4,12)
    %     imshowpair(fixed(:,:,13), MOVING_transformed(:,:,13),'Scaling','joint');
    %     subplot(4,4,13)
    %     imshowpair(fixed(:,:,14), MOVING_transformed(:,:,14),'Scaling','joint');
    %     subplot(4,4,14)
    %     imshowpair(fixed(:,:,15), MOVING_transformed(:,:,15),'Scaling','joint');
    %     subplot(4,4,15)
    %     imshowpair(fixed(:,:,16), MOVING_transformed(:,:,16),'Scaling','joint');
    %     subplot(4,4,16)
    %     imshowpair(fixed(:,:,17), MOVING_transformed(:,:,17),'Scaling','joint');
    
    %% Show MIP Image
    %figure(3);clf
    
    %% Format MIP Image
    MIP = max(image,[],4);
    clear image
    MIP = imresize(MIP,[128,128]);
    
    %% Select only MIP inside anatomic
    f19_lung = MIP.*double(MOVING_transformed);
    plot_title = sprintf('Subject %i', patients(i));
    %
    %     window_f19 = [16 45];
    
    %
    %     subplot(4,4,1)
    %     imshow(f19_lung(:,:,2), window_f19)
    %     title(plot_title)
    %
    %     subplot(4,4,2)
    %     imshow(f19_lung(:,:,3), window_f19)
    %     subplot(4,4,3)
    %     imshow(f19_lung(:,:,4), window_f19)
    %     subplot(4,4,4)
    %     imshow(f19_lung(:,:,5), window_f19)
    %     subplot(4,4,5)
    %     imshow(f19_lung(:,:,6), window_f19)
    %     subplot(4,4,6)
    %     imshow(f19_lung(:,:,7), window_f19)
    %     subplot(4,4,7)
    %     imshow(f19_lung(:,:,8), window_f19)
    %     subplot(4,4,8)
    %     imshow(f19_lung(:,:,9), window_f19)
    %     subplot(4,4,9)
    %     imshow(f19_lung(:,:,10), window_f19)
    %     subplot(4,4,10)
    %     imshow(f19_lung(:,:,11), window_f19)
    %     subplot(4,4,11)
    %     imshow(f19_lung(:,:,12), window_f19)
    %     subplot(4,4,12)
    %     imshow(f19_lung(:,:,13), window_f19)
    %     subplot(4,4,13)
    %     imshow(f19_lung(:,:,14), window_f19)
    %     subplot(4,4,14)
    %     imshow(f19_lung(:,:,15), window_f19)
    %     subplot(4,4,15)
    %     imshow(f19_lung(:,:,16), window_f19)
    %     subplot(4,4,16)
    %     imshow(f19_lung(:,:,17), window_f19)
    
    
    %     %% Save figure (optional)
    %     FigureDirectory    = strcat('G:\2017-Glass\f19_fit_results\MIP_registered\moderateORsevere\');  mkdir(FigureDirectory);
    %     FigureName = strcat('Registration_Patient_',string(patients(i)));
    %     FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    %     saveas(gcf,FileName)
    
    %% Get Values for lowvent, midvent, highvent
    [low_vent, mid_vent, high_vent] = FindMIPThresholdValues(MIP);
    
    %% Create RGB Maps for Image
    % background = 0.5 is just above 0
    [f19_rgb UnventilatedMap MinimalVentMap ModerateVentMap HighVentMap] = PlotRGB_f19(patients(i),f19_lung, 0.5, low_vent, mid_vent, high_vent);
    
    %% Create 6 Segments
    [ UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight ] = ComputeSixLungSegments( MOVING_transformed );
    PlotSixLungSegmentsRGB(patients(i) , UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight)
    UpperLeftVolumes(i)   = sum(UpperLeft(:)  )*.3125*.3125*1.5;
    MiddleLeftVolumes(i)  = sum(MiddleLeft(:) )*.3125*.3125*1.5;
    LowerLeftVolumes(i)   = sum(LowerLeft(:)  )*.3125*.3125*1.5;
    UpperRightVolumes(i)  = sum(UpperRight(:) )*.3125*.3125*1.5;
    MiddleRightVolumes(i) = sum(MiddleRight(:))*.3125*.3125*1.5;
    LowerRightVolumes(i)  = sum(LowerRight(:) )*.3125*.3125*1.5;
    
    % Plot Unventilated Map
    %PlotUnventilatedMap(patients(i),UnventilatedMap);
    
    %     %% Create histograms for each subject
    %     histogram(f19_lung(f19_lung>0)) % only vals inside lung
    %     title(sprintf('Subject %i F19 Intensity Histogram', patients(i)))
    %     xlabel('Pixel Intensity')
    %     ylabel('Number of Pixels')
    %     xlim([0 130])
    %     ylim([0 4000])
    
    %     %% Save figure (optional)
    %     FigureDirectory    = strcat('G:\2017-Glass\f19_fit_results\f19_histogram\moderate-severe\');  mkdir(FigureDirectory);
    %     FigureName = strcat('Registration_Patient_',string(patients(i)));
    %     FileName = char(strcat(FigureDirectory,FigureName,'.png'));
    %     saveas(gcf,FileName)
    %
    %% Pause and return to home
    pause(0.01)
    cd(home)
    
    %% Compute Ventilated Volumes By Type
    AnatomicVolumes(i) = sum(MOVING_transformed(:))*.3125*.3125*1.5;
    UnventilatedVolumes(i) = sum(UnventilatedMap(:))*.3125*.3125*1.5;
    MinimallyVentilatedVolumes(i)  = sum(MinimalVentMap(:) )*.3125*.3125*1.5;
    ModeratelyVentilatedVolumes(i) = sum(ModerateVentMap(:))*.3125*.3125*1.5;
    HighlyVentilatedVolumes(i)     = sum(HighVentMap(:)    )*.3125*.3125*1.5;
    
end

% Display to command
AnatomicVolumes = AnatomicVolumes'

MinimalVentPercent = 100*(UnventilatedVolumes'+MinimallyVentilatedVolumes')./AnatomicVolumes


VentilationDefectPercent = 100*UnventilatedVolumes'./AnatomicVolumes
MEAN_VDP = mean(VentilationDefectPercent)
STD_VDP  = std(VentilationDefectPercent)

MEAN_MVP = mean(MinimalVentPercent)
STD_MVP  = std(MinimalVentPercent)

%close all

%% Write Ventilation Data to CSV
WriteCSVData = 0;
if WriteCSVData
    % create data matrix
    f19DataMatrix = [patients AnatomicVolumes UnventilatedVolumes' MinimallyVentilatedVolumes' ModeratelyVentilatedVolumes' HighlyVentilatedVolumes'...
                     100*UnventilatedVolumes'./AnatomicVolumes 100*MinimallyVentilatedVolumes'./AnatomicVolumes ...
                     100*ModeratelyVentilatedVolumes'./AnatomicVolumes 100*HighlyVentilatedVolumes'./AnatomicVolumes];
    % make header
    cHeader = {'PatientNumber' 'AnatomicVolume(mL)' 'UnventilatedVolume(mL)' 'LowVentVolume(mL)' 'MediumVentVolume(mL)' 'HighVentVolume(mL)' 'Unventilated%' 'LowVent%' 'MediumVent%' 'HighVent%' };
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid = fopen('G:\2017-Glass\f19_fit_results\F19ventilationdata.csv','w');
    fprintf(fid,'%s\n',textHeader);
    fclose(fid);
    %write data to end of file
    dlmwrite('G:\2017-Glass\f19_fit_results\F19ventilationdata.csv',f19DataMatrix,'-append');    
end

