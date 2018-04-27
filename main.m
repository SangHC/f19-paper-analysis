%% main.m
% Tyler Glass
% Code for running f19 lobar analysis

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions

%% Data for First and Last PFP Times
patientNumbers = [2; 3; 4; 5; 7; 8; 9; 10; 11; 12; 13; 14; 15; 16; 17; 18; 19; 20; 21; 22; 24; 25];
first_PFP      = [2; 1; 2; 2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2;  2];
last_PFP       = [7; 5; 7; 7; 7; 7; 6;  6;  6;  7;  6;  5;  7;  6;  6;  7;  6;  6;  6;  6;  4;  6]; % updated 11/11/2017

all = [2;3;4;5;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;24;25];
normals = [2;3;4;5;11;15;16;17;19;21;26];
mild = [9;10;13;18;20;24;25];
moderate = [7;8;12;14;22];

%% Selected Image Data
f19_pixel_size = 0.625; % cm
f19_slice_thickness = 1.5; % cm
anatomic_pixel_size = 0.3125; % cm
anatomic_slice_thickness = 1.5; % cm

%% Loop Through all F19 Patients
tic

patientNumbers = [26]; % edit this

for i=1:length(patientNumbers)
    %% Load F19 Ventilation Data
    cd('./data/f19_ventilation_segmentations')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename);
    moving = imresize(roi,[128,128]); % f19 is moving
    f19 = image;
    ventilation = roi;
    cd(home)

    %% Load Anatomic MRI and Lobar Segmentations
    cd('./data/inspiration_lobar_segmentations')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename)
    fixed = imresize(WholeLung, [128,128]); % anat is fixed
    fixed(:,:,16:18) = 0; % make fixed the same size as moving functional
    
    % load anatomic MRI
    inspirationMRI = MR1;
    inspirationMRI(:,:,16:18) = 0;
    % load lobar segs
    LeftLowerLobeSegs(:,:,:,i) = LeftLowerLobe;
    LeftUpperLobeSegs(:,:,:,i) = LeftUpperLobe;
    RightLowerLobeSegs(:,:,:,i) = RightLowerLobe;
    RightMiddleLobeSegs(:,:,:,i) = RightMiddleLobe;
    RightUpperLobeSegs(:,:,:,i) = RightUpperLobe;
    % make lobar segs same size as image
    LeftLowerLobe   = imresize(LeftLowerLobe, [128,128]);
    LeftUpperLobe   = imresize(LeftUpperLobe, [128,128]);
    RightLowerLobe  = imresize(RightLowerLobe, [128,128]);
    RightMiddleLobe = imresize(RightMiddleLobe, [128,128]);
    RightUpperLobe  = imresize(RightUpperLobe, [128,128]);
    % make lobar segs same size as moving functional
    LeftLowerLobe(:,:,16:18) = 0;
    LeftUpperLobe(:,:,16:18) = 0;
    RightLowerLobe(:,:,16:18) = 0;
    RightMiddleLobe(:,:,16:18) = 0;
    RightUpperLobe(:,:,16:18) = 0;
    
    cd(home)
    
    %figure(2);clf
    %imshow(int16(fixed(:,:,8)).*inspirationMRI(:,:,8),[])
    
    %% Get Transform by Registering F19 Moving map to Inspiration 1H Fixed
    [optimizer, metric] = imregconfig('monomodal');
    tform = imregtform(uint8(moving), uint8(fixed), 'affine', optimizer, metric);

    
    %% Create 4D transformed F19 image with tform
    for timestep = 1:size(f19,4)
        moving_f19 = imresize(f19(:,:,:,timestep),[128 128]);
        f19_registered(:,:,:,timestep) = imwarp(moving_f19, tform , 'OutputView', imref3d(size(fixed)));
    end
    
    %% Show figure to confirm registration
    figure(1);clf
    f19_timestep = 5;
    slice1 = 4;
    slice2 = 6;
    slice3 = 8;
    slice4 = 10;
    slice5 = 12;
    subplot(5,4,1)
    imshow(f19_registered(:,:,slice1,f19_timestep),[])
    subplot(5,4,2)
    imshow(inspirationMRI(:,:,slice1),[])
    subplot(5,4,3)
    imshow(RightLowerLobe(:,:,slice1),[])
    subplot(5,4,4)
    imshow(LeftUpperLobe(:,:,slice1),[])
    subplot(5,4,5)
    imshow(f19_registered(:,:,slice2,f19_timestep),[])
    subplot(5,4,6)
    imshow(inspirationMRI(:,:,slice2),[])
    subplot(5,4,7)
    imshow(RightLowerLobe(:,:,slice2),[])
    subplot(5,4,8)
    imshow(LeftUpperLobe(:,:,slice2),[])
    subplot(5,4,9)
    imshow(f19_registered(:,:,slice3,f19_timestep),[])
    subplot(5,4,10)
    imshow(inspirationMRI(:,:,slice3),[])
    subplot(5,4,11)
    imshow(RightLowerLobe(:,:,slice3),[])
    subplot(5,4,12)
    imshow(LeftUpperLobe(:,:,slice3),[])
    subplot(5,4,13)
    imshow(f19_registered(:,:,slice4,f19_timestep),[])
    subplot(5,4,14)
    imshow(inspirationMRI(:,:,slice4),[])
    subplot(5,4,15)
    imshow(RightLowerLobe(:,:,slice4),[])
    subplot(5,4,16)
    imshow(LeftUpperLobe(:,:,slice4),[])
    subplot(5,4,17)
    imshow(f19_registered(:,:,slice5,f19_timestep),[])
    subplot(5,4,18)
    imshow(inspirationMRI(:,:,slice5),[])
    subplot(5,4,19)
    imshow(RightLowerLobe(:,:,slice5),[])
    subplot(5,4,20)
    imshow(LeftUpperLobe(:,:,slice5),[])
    
    %% Grab whole lung and lobes in time that are in anatomic segmentation
    for timestep = 1:size(f19,4)
        WholeLung_ventilated(:,:,:,timestep) = fixed .* f19_registered(:,:,:,timestep);
        
        RUL_ventilated(:,:,:,timestep) = RightUpperLobe  .* f19_registered(:,:,:,timestep);
        RML_ventilated(:,:,:,timestep) = RightMiddleLobe .* f19_registered(:,:,:,timestep);
        RLL_ventilated(:,:,:,timestep) = RightLowerLobe  .* f19_registered(:,:,:,timestep);
        LUL_ventilated(:,:,:,timestep) = LeftUpperLobe   .* f19_registered(:,:,:,timestep);
        LLL_ventilated(:,:,:,timestep) = LeftLowerLobe   .* f19_registered(:,:,:,timestep);   
    end
    
    %% Find median of lobe at each timepoint
    for timestep = 1:size(f19,4)
        RUL_median_vals(timestep) = ComputeMedianOfLobe(RUL_ventilated(:,:,:,timestep));
        RML_median_vals(timestep) = ComputeMedianOfLobe(RML_ventilated(:,:,:,timestep));
        RLL_median_vals(timestep) = ComputeMedianOfLobe(RLL_ventilated(:,:,:,timestep));
        LUL_median_vals(timestep) = ComputeMedianOfLobe(LUL_ventilated(:,:,:,timestep));
        LLL_median_vals(timestep) = ComputeMedianOfLobe(LLL_ventilated(:,:,:,timestep));
        
    end
    
    %% Plot lobar medians on one plot
    figure(3);clf
    plot(RUL_median_vals, 'g*-')
    hold on
    plot(RML_median_vals, 'b*-')
    hold on
    plot(RLL_median_vals, 'r*-')
    hold on
    plot(LUL_median_vals, 'm*-')
    hold on
    plot(LLL_median_vals, 'k*-')
    hold on
    legend('RUL','RML','RLL','LUL','LLL')
    
    
end

%% Print Elapsed Processing Time
toc