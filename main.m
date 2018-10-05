%% Initialize
clear;clc;
home = pwd;

%% Subject Groups
all = ['13A','13B','18A','18B','28A','28B','32A','32B','33A','33B','42A','42B'];
normals = [2;3;4;5;15;16;17;19;26;31;37;39;40;41];
mild = [9;13;18;20;24;25;28;29;30;32;33;35];
moderate = [7;8;10;12;14;34];

%% Choose Parameters for Running
% Choose patients
patients = ['111']; %;'013B';'018A';'028A'];
% patients = ['033B'];
% MIP image - 2 1
PlotMIPImageBool = 1;
SaveMIPImageBool = 1;
% RGB Image - figure 2
PlotRGBImageBool = 1;
SaveRGBImageBool = 1;
% Six Segment Image - figure 3
PlotSixSegmentModelBool = 0; 
SaveSixSegmentModelBool =0;
% F19 histogram image - figure 4
PlotF19HistogramBool = 1; 
% Save CSV ventilation data to file
WriteCSVVentilationDataBool = 1;
% Save tau1 data to file
WriteTau1DataBool = 1;

%% Loop through selected subjects
for i = 1:size(patients,1)
    %% Load and Format Initial Imaging Data
    % load f19 ventilaion
    %cd('G:\2017-Glass\mim\f19_ventilation_segmentations')
    cd('.\data')
    filename = strcat('2569-',patients(i,:),'_f19.mat');
    load(filename);
    % format fixed F19 image to same size as moving 1h mri
    fixed = imresize(roi,[128,128]);
    cd(home)
    
    % load anatomical 1h mri
    cd('.\data')
  
        filename = strcat('2569-',patients(i,:),'_anat.mat');
        load(filename)
    % format anatomical 1h mri moving image
    moving = imresize(inspiration_ROI, [128,128]);
    moving(:,:,16:18) = 0; % add slices to make equal image sizes
    
    % back to home directory and add functions path
    cd(home)
    addpath('./functions')
       
    %% Stretch moving to match respiratory effort of fixed
    [moving ApexBaseStretchRatio(i) LeftRightStretchRatio(i)] = Stretch_Functional3D(moving,fixed);
    
    %% Use Translation Registration to Align Images
    [optimizer, metric] = imregconfig('monomodal');
    MOVING_transformed = imregister(uint8(moving), uint8(fixed), 'translation', optimizer, metric);
    
    %% Remove end slices from registered anatomic outline
    MOVING_transformed = RemoveEdgeSlices(MOVING_transformed);
       
    %% Format MIP Image
    f19_RAW = image;
    MIP = max(image,[],4);
    clear image % to avoid variable name confusion
    MIP = imresize(MIP,[128,128]);    
    % Select only MIP inside anatomic
    f19_lung = MIP.*double(MOVING_transformed);
    
    %% Plot F19 Histogram on Figure 4 if selected
    if PlotF19HistogramBool
        [P90data(i) , meantop10data(i)] = PlotF19Histogram(patients(i,:), f19_lung);
    end
    
    %% Compute Values for lowvent, midvent, highvent
    [low_vent(i), mid_vent(i), high_vent(i), max_vent(i)] = FindMIPThresholdValues(MIP , f19_lung);
    
    %% Plot MIP Image on Figure 1 if Selected
    if PlotMIPImageBool
        PlotMIPImage(patients(i,:), SaveMIPImageBool, f19_lung, low_vent(i), high_vent(i))
    end
    
    %% Create and Plot RGB Maps on Figure 2 if selected
    [f19_rgb , UnventilatedMap ,  LowVentMap , MiddleVentMap , HighVentMap] = PlotRGB_f19(patients(i,:),PlotRGBImageBool,SaveRGBImageBool,f19_lung, 0.5, low_vent(i), mid_vent(i), high_vent(i));
    
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
        PlotSixLungSegmentsRGB(patients(i,:) , SaveSixSegmentModelBool,UpperLeft, MiddleLeft, LowerLeft, UpperRight, MiddleRight, LowerRight)
    end
    
    %% Return home
    cd(home)
    
    %% Compute Ventilated Volumes By Type
    AnatomicVolumes(i)         = sum(MOVING_transformed(:))*0.3125*0.3125*1.5;
    UnventilatedVolumes(i)     = sum(UnventilatedMap(:))   *0.3125*0.3125*1.5;
    LowVentilatedVolumes(i)    = sum(LowVentMap(:))        *0.3125*0.3125*1.5;
    MiddleVentilatedVolumes(i) = sum(MiddleVentMap(:))     *0.3125*0.3125*1.5;
    HighVentilatedVolumes(i)   = sum(HighVentMap(:))       *0.3125*0.3125*1.5;
    
    %% Compute Washin and Washout Dynamics
    if WriteTau1DataBool
        % load data for First and Last PFP Times
        first_last_PFP_data = load('first_last_PFP.txt');
        first_PFP = first_last_PFP_data(2,:);
        last_PFP = first_last_PFP_data(3,:);
        % print when starting
        fprintf('\n\n\nStarting Patient %03d', patients(i,:))
        % Get mask for ventilated pixels from MIIT using threshold
        ROI_VentilationDynamics = f19_lung > low_vent(i);
        % Process Split Fit
%         [ dF , tau1 , r2_Washin , d0 , tau2 , r2_Washout ] =  SplitFitProcess( f19_RAW , ROI_VentilationDynamics , scantimes , first_PFP(i), last_PFP(i) );
        % Normal Fit Process
        [ tau1 , tau2 , r2 , mask, d0 , dF, t0 , t1] = NormalFitProcessAllOutput( f19_RAW , roi , scantimes , last_PFP(i) );
        % Get mask variable
        [ PixelAverageMeans , mask ] = ComputePixelAverageIn3DROI( f19_RAW, ROI_VentilationDynamics );
                %% Boolean Tau_1 filter
        for fix=1:1:64 
            for fiy=1:1:64
                for fiz=1:1:18
                    if (tau1(fix,fiy,fiz) < tau2(fix,fiy,fiz)*0.75) || (tau1(fix,fiy,fiz) > 590)|| (tau1(fix,fiy,fiz) < 5)
                        tau1(fix,fiy,fiz) = 0;
                        tau2(fix,fiy,fiz) = 0;
                    end
                    if (tau2(fix,fiy,fiz) < 5) ||(tau2(fix,fiy,fiz) > 590)
                        tau1(fix,fiy,fiz) = 0;
                        tau2(fix,fiy,fiz) = 0;
                    end
                end
            end
        end
        
        %% plot and save tau maps
        figure
        for p = 1:1:18
            %    figure
            subplot(4,5,p)
            image(tau1(:,:,p))
            title('Tau 1')
        end
        %         mkdir('./outputs/f19_tau_figures/');
        %         PatientTitle = strcat('Patient_',num2str(patients(i,:),'_Tau1','%03d'));
        %         saveas(gcf,strcat('./outputs/f19_tau_figures/',PatientTitle,'.png'))
        
        figure
        for q = 1:1:18
            %    figure
            subplot(4,5,q)
            image(tau2(:,:,q))
            title('Tau 2')
        end
        
%         mkdir('./outputs/f19_tau_figures/');
%         PatientTitle = strcat('Patient_',num2str(patients(i,:),'_Tau1','%03d'));
%         saveas(gcf,strcat('./outputs/f19_tau_figures/',PatientTitle,'.png'))
        %%
        % Plot Results
%         PlotSplitFitResultsv2( patients(i,:), './outputs/f19_fit_figures/', tau1, tau2, dF, d0, r2_Washin, r2_Washout, mask )
       
        % Save Parameters
%         SaveFitParameterData(patients(i,:), './outputs/f19_fit_parameters/', tau1, tau2, dF, d0)
    end
    
    %% Output .csv format table
[data] = xyz_show(mask,imresize(MIP,[64,64]),tau1,tau2,d0,dF,t0,t1,patients(i,:));
end

VDP = (100*UnventilatedVolumes./AnatomicVolumes)'
meanVDP = mean(VDP)
stdVDP  = std(VDP)
LVP = (100*(UnventilatedVolumes+LowVentilatedVolumes)./AnatomicVolumes)';
meanLVP = mean(LVP)
stdLVP  = std(LVP)
max_vent';
meanMaxVent = mean(max_vent)

%% Write Ventilation Data to CSV if Selected
if WriteCSVVentilationDataBool
    % create data matrix
    f19DataMatrix = [string(patients) AnatomicVolumes' UnventilatedVolumes' LowVentilatedVolumes' MiddleVentilatedVolumes' HighVentilatedVolumes'...
                     100*UnventilatedVolumes'./AnatomicVolumes' 100*LowVentilatedVolumes'./AnatomicVolumes' ...
                     100*MiddleVentilatedVolumes'./AnatomicVolumes' 100*HighVentilatedVolumes'./AnatomicVolumes'];
    % make header
    cHeader = {'PatientNumber' 'AnatomicVolume(mL)' 'UnventilatedVolume(mL)' 'LowVentVolume(mL)' 'MediumVentVolume(mL)' 'HighVentVolume(mL)' 'Unventilated%' 'LowVent%' 'MediumVent%' 'HighVent%' };
    commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
    commaHeader = commaHeader(:)';
    textHeader = cell2mat(commaHeader); %cHeader in text with commas
    %write header to file
    fid = fopen('.\outputs\F19ventilationdata.csv','a');
    % 'w' overwrite data
    % 'a' append data
    fprintf(fid,'%s\n',textHeader);
    for index = 1:size(patients,1)
        fprintf(fid,'%s,%f,%f,%f,%f,%f,%f,%f,%f,%f\n',f19DataMatrix(index,:));
    end
    fclose(fid);
end

