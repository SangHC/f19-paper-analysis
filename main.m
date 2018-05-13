%% Initialize
clear;clc;
home = pwd;

%% Select Subjects and Visualization
%subject groups
all = [2;3;4;5;7;8;9;10;12;13;14;15;16;17;18;19;20;24;25;26;28;29;30;31;32;33;34;35;37;39;40];
normals = [2;3;4;5;15;16;17;19;26;31;37;39;40];
mild = [9;13;18;20;24;25;28;29;30;32;33;35];
moderate = [7;8;10;12;14;34];

% choose subjects
patients = 14;

% choose visualization and saving steps

%% Loop through selected subjects
for i = 1:length(patients)
    
    %% Load and Format Initial Imaging Data
    % load f19 ventilaion
    cd('G:\2017-Glass\mim\f19_ventilation_segmentations')
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename);
    % format fixed F19 image to same size as moving 1h mri
    fixed = imresize(roi,[128,128]);
    
    % load anatomical 1h mri
    cd('G:\2017-Glass\mim\inspiration_anatomic_segmentations')
    filename = strcat('0509-',num2str(patients(i),'%03d'),'.mat');
    load(filename)
    % format anatomical 1h mri moving image
    moving = imresize(inspiration_ROI, [128,128]);
    moving(:,:,16:18) = 0; % add slices to make equal image sizes
    
    % back to home directory and add functions path
    cd(home)
    addpath('./functions')
       
    %% Stretch moving to match respiratory effort of fixed
    moving = Stretch_Functional3D(moving,fixed);
    
    %% Use Translation Registration to Align Images
    [optimizer, metric] = imregconfig('monomodal');
    MOVING_transformed = imregister(uint8(moving), uint8(fixed), 'translation', optimizer, metric);
    
    %% Remove end slices from registered anatomic outline
    MOVING_transformed = RemoveEdgeSlices(MOVING_transformed);
    
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
    
    %% Create 6 Segment Model and Compute Volumes of Segments
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
    AnatomicVolumes(i)             = sum(MOVING_transformed(:))*0.3125*0.3125*1.5;
    UnventilatedVolumes(i)         = sum(UnventilatedMap(:))   *0.3125*0.3125*1.5;
    MinimallyVentilatedVolumes(i)  = sum(MinimalVentMap(:))    *0.3125*0.3125*1.5;
    ModeratelyVentilatedVolumes(i) = sum(ModerateVentMap(:))   *0.3125*0.3125*1.5;
    HighlyVentilatedVolumes(i)     = sum(HighVentMap(:))       *0.3125*0.3125*1.5;
    
end

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