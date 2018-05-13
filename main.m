%% Initialize
clear;clc;
home = pwd;

%% Subject Groups
all = [2;3;4;5;7;8;9;10;12;13;14;15;16;17;18;19;20;24;25;26;28;29;30;31;32;33;34;35;37;39;40];
normals = [2;3;4;5;15;16;17;19;26;31;37;39;40];
mild = [9;13;18;20;24;25;28;29;30;32;33;35];
moderate = [7;8;10;12;14;34];

%% Choose Parameters for Running
% Choose patients
patients = all;
% MIP image - figure 1
PlotMIPImageBool = 0;
SaveMIPImageBool = 0;
% RGB Image - figure 2
PlotRGBImageBool = 0;
SaveRGBImageBool = 0;
% Six Segment Image - figure 3
PlotSixSegmentModelBool = 0; 
SaveSixSegmentModelBool =0; 
% Save CSV data to file
WriteCSVDataBool = 1; 

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
       
    %% Format MIP Image
    MIP = max(image,[],4);
    clear image % to avoid variable name confusion
    MIP = imresize(MIP,[128,128]);    
    % Select only MIP inside anatomic
    f19_lung = MIP.*double(MOVING_transformed);
    
    %% Compute Values for lowvent, midvent, highvent
    [low_vent, mid_vent, high_vent] = FindMIPThresholdValues(MIP);
    
    %% Plot MIP Image on Figure 1 if Selected
    if PlotMIPImageBool
        PlotMIPImage(patients(i), SaveMIPImageBool, f19_lung, low_vent, high_vent)
    end
    
    %% Create and Plot RGB Maps on Figure 2 if selected
    [f19_rgb , UnventilatedMap ,  LowVentMap , MiddleVentMap , HighVentMap] = PlotRGB_f19(patients(i),PlotRGBImageBool,SaveRGBImageBool,f19_lung, 0.5, low_vent, mid_vent, high_vent);
    
    %% Create 6 Segment Model and Compute Volumes of Segments
    [ UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight ] = ComputeSixLungSegments( MOVING_transformed );
    UpperLeftVolumes(i)   = sum(UpperLeft(:)  )*.3125*.3125*1.5;
    MiddleLeftVolumes(i)  = sum(MiddleLeft(:) )*.3125*.3125*1.5;
    LowerLeftVolumes(i)   = sum(LowerLeft(:)  )*.3125*.3125*1.5;
    UpperRightVolumes(i)  = sum(UpperRight(:) )*.3125*.3125*1.5;
    MiddleRightVolumes(i) = sum(MiddleRight(:))*.3125*.3125*1.5;
    LowerRightVolumes(i)  = sum(LowerRight(:) )*.3125*.3125*1.5;
    
    %% Plot Six Segment Model on Figure 3 if Selected
    if PlotSixSegmentModelBool
        PlotSixLungSegmentsRGB(patients(i) , SaveSixSegmentModelBool,UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight)
    end
    
    %% Pause and return to home
    pause(0.01)
    cd(home)
    
    %% Compute Ventilated Volumes By Type
    AnatomicVolumes(i)         = sum(MOVING_transformed(:))*0.3125*0.3125*1.5;
    UnventilatedVolumes(i)     = sum(UnventilatedMap(:))   *0.3125*0.3125*1.5;
    LowVentilatedVolumes(i)    = sum(LowVentMap(:))        *0.3125*0.3125*1.5;
    MiddleVentilatedVolumes(i) = sum(MiddleVentMap(:))     *0.3125*0.3125*1.5;
    HighVentilatedVolumes(i)   = sum(HighVentMap(:))       *0.3125*0.3125*1.5;
    
end

%% Write Ventilation Data to CSV if Selected
if WriteCSVDataBool
    % create data matrix
    f19DataMatrix = [patients AnatomicVolumes' UnventilatedVolumes' LowVentilatedVolumes' MiddleVentilatedVolumes' HighVentilatedVolumes'...
                     100*UnventilatedVolumes'./AnatomicVolumes' 100*LowVentilatedVolumes'./AnatomicVolumes' ...
                     100*MiddleVentilatedVolumes'./AnatomicVolumes' 100*HighVentilatedVolumes'./AnatomicVolumes'];
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