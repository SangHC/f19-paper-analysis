%% main.m
% Tyler Glass
% Code for running f19 lobar analysis

%% Initialize Workspace
clear; clc; close all
home = pwd;
addpath('./functions') % Add path for f19 processing functions

%% Selected Image Data
f19_pixel_size = 0.625; % cm
f19_slice_thickness = 1.5; % cm
anatomic_pixel_size = 0.3125; % cm
anatomic_slice_thickness = 1.5; % cm

%% Select Patients
% be sure to change legend if edit patients
patientNumbers = [2; 3; 4; 5; 11; 15; 16; 17; 19; 21; 26];
first_PFP      = [2; 1; 2; 2;  2;  2;  2;  2;  2;  2;  2];
last_PFP       = [7; 5; 7; 7;  6;  7;  6;  6;  6;  6;  6]; % updated 3/9/2018


%% Start timer
tic

%% Loop patients to get medians data
for i=1:length(patientNumbers)
    %% Load Medians Data
    cd('./medians1')
    filename = strcat('0509-',num2str(patientNumbers(i),'%03d'),'.mat');
    load(filename);
    cd(home)
    
    %% Select Washin lobar data for each patient
    RUL_washin(i,:) = RUL_median_vals(first_PFP(i):first_PFP(i)+4);
    RML_washin(i,:) = RML_median_vals(first_PFP(i):first_PFP(i)+4);
    RLL_washin(i,:) = RLL_median_vals(first_PFP(i):first_PFP(i)+4);
    LUL_washin(i,:) = LUL_median_vals(first_PFP(i):first_PFP(i)+4);
    LLL_washin(i,:) = LLL_median_vals(first_PFP(i):first_PFP(i)+4);
    
    %% Select washout lobar data for each patient
    RUL_washout(i,:) = RUL_median_vals(last_PFP(i):last_PFP(i)+4);
    RML_washout(i,:) = RML_median_vals(last_PFP(i):last_PFP(i)+4);
    RLL_washout(i,:) = RLL_median_vals(last_PFP(i):last_PFP(i)+4);
    LUL_washout(i,:) = LUL_median_vals(last_PFP(i):last_PFP(i)+4);
    LLL_washout(i,:) = LLL_median_vals(last_PFP(i):last_PFP(i)+4);
    
end

%% Change directory to plots
cd('./plots')

%% Make Lobar mean washin plot
figure(1);clf
plot(mean(RUL_washin), 'g*-')
hold on
plot(mean(RML_washin), 'b*-')
hold on
plot(mean(RLL_washin), 'r*-')
hold on
plot(mean(LUL_washin), 'm*-')
hold on
plot(mean(LLL_washin), 'k*-')
hold on
legend('RUL','RML','RLL','LUL','LLL')
xlabel('Timestep')
ylabel('Averaged Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity for Contrast Wash-in for Averaged Normals')
print('AveragedNormals_washin','-dpng','-r0')

%% Make Lobar mean washout plot
figure(2);clf

plot(mean(RUL_washout), 'g*-')
hold on
plot(mean(RML_washout), 'b*-')
hold on
plot(mean(RLL_washout), 'r*-')
hold on
plot(mean(LUL_washout), 'm*-')
hold on
plot(mean(LLL_washout), 'k*-')

legend('RUL','RML','RLL','LUL','LLL')
xlabel('Timestep')
ylabel('Averaged Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity for Contrast Wash-out for Averaged Normals')
print('AveragedNormals_washout','-dpng','-r0')

%% Make RUL plot for each patient
figure(3);clf

plot(RUL_washin(1,:),  'k-')
hold on
plot(RUL_washin(2,:),  'm-')
hold on
plot(RUL_washin(3,:),  'c-')
hold on
plot(RUL_washin(4,:),  'r-')
hold on
plot(RUL_washin(5,:),  'g-')
hold on
plot(RUL_washin(6,:),  'b-')
hold on
plot(RUL_washin(7,:),  'w-')
hold on
plot(RUL_washin(8,:),  'k-')
hold on
plot(RUL_washin(9,:),  'y-')
hold on
plot(RUL_washin(10,:), 'm-')
hold on
plot(RUL_washin(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RUL for Contrast Wash-in')
print('RUL_washin','-dpng','-r0')

%% Make RML plot for each patient
figure(4);clf

plot(RML_washin(1,:),  'k-')
hold on
plot(RML_washin(2,:),  'm-')
hold on
plot(RML_washin(3,:),  'c-')
hold on
plot(RML_washin(4,:),  'r-')
hold on
plot(RML_washin(5,:),  'g-')
hold on
plot(RML_washin(6,:),  'b-')
hold on
plot(RML_washin(7,:),  'w-')
hold on
plot(RML_washin(8,:),  'k-')
hold on
plot(RML_washin(9,:),  'y-')
hold on
plot(RML_washin(10,:), 'm-')
hold on
plot(RML_washin(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RML for Contrast Wash-in')
print('RML_washin','-dpng','-r0')

%% Make RLL plot for each patient
figure(5);clf

plot(RLL_washin(1,:),  'k-')
hold on
plot(RLL_washin(2,:),  'm-')
hold on
plot(RLL_washin(3,:),  'c-')
hold on
plot(RLL_washin(4,:),  'r-')
hold on
plot(RLL_washin(5,:),  'g-')
hold on
plot(RLL_washin(6,:),  'b-')
hold on
plot(RLL_washin(7,:),  'w-')
hold on
plot(RLL_washin(8,:),  'k-')
hold on
plot(RLL_washin(9,:),  'y-')
hold on
plot(RLL_washin(10,:), 'm-')
hold on
plot(RML_washin(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RLL for Contrast Wash-in')
print('RLL_washin','-dpng','-r0')

%% Make LUL plot for each patient
figure(6);clf

plot(LUL_washin(1,:),  'k-')
hold on
plot(LUL_washin(2,:),  'm-')
hold on
plot(LUL_washin(3,:),  'c-')
hold on
plot(LUL_washin(4,:),  'r-')
hold on
plot(LUL_washin(5,:),  'g-')
hold on
plot(LUL_washin(6,:),  'b-')
hold on
plot(LUL_washin(7,:),  'w-')
hold on
plot(LUL_washin(8,:),  'k-')
hold on
plot(LUL_washin(9,:),  'y-')
hold on
plot(LUL_washin(10,:), 'm-')
hold on
plot(LUL_washin(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in LUL for Contrast Wash-in')
print('LUL_washin','-dpng','-r0')

%% Make LLL plot for each patient
figure(7);clf

plot(LLL_washin(1,:),  'k-')
hold on
plot(LLL_washin(2,:),  'm-')
hold on
plot(LLL_washin(3,:),  'c-')
hold on
plot(LLL_washin(4,:),  'r-')
hold on
plot(LLL_washin(5,:),  'g-')
hold on
plot(LLL_washin(6,:),  'b-')
hold on
plot(LLL_washin(7,:),  'w-')
hold on
plot(LLL_washin(8,:),  'k-')
hold on
plot(LLL_washin(9,:),  'y-')
hold on
plot(LLL_washin(10,:), 'm-')
hold on
plot(LLL_washin(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in LUL for Contrast Wash-in')
print('LLL_washin','-dpng','-r0')

%% Make RUL plot for each patient
figure(8);clf

plot(RUL_washout(1,:),  'k-')
hold on
plot(RUL_washout(2,:),  'm-')
hold on
plot(RUL_washout(3,:),  'c-')
hold on
plot(RUL_washout(4,:),  'r-')
hold on
plot(RUL_washout(5,:),  'g-')
hold on
plot(RUL_washout(6,:),  'b-')
hold on
plot(RUL_washout(7,:),  'w-')
hold on
plot(RUL_washout(8,:),  'k-')
hold on
plot(RUL_washout(9,:),  'y-')
hold on
plot(RUL_washout(10,:), 'm-')
hold on
plot(RUL_washout(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RUL for Contrast Wash-out')
print('RUL_washout','-dpng','-r0')

%% Make RML plot for each patient
figure(9);clf

plot(RML_washout(1,:),  'k-')
hold on
plot(RML_washout(2,:),  'm-')
hold on
plot(RML_washout(3,:),  'c-')
hold on
plot(RML_washout(4,:),  'r-')
hold on
plot(RML_washout(5,:),  'g-')
hold on
plot(RML_washout(6,:),  'b-')
hold on
plot(RML_washout(7,:),  'w-')
hold on
plot(RML_washout(8,:),  'k-')
hold on
plot(RML_washout(9,:),  'y-')
hold on
plot(RML_washout(10,:), 'm-')
hold on
plot(RML_washout(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RML for Contrast Wash-out')
print('RML_washout','-dpng','-r0')

%% Make RLL plot for each patient
figure(10);clf

plot(RLL_washout(1,:),  'k-')
hold on
plot(RLL_washout(2,:),  'm-')
hold on
plot(RLL_washout(3,:),  'c-')
hold on
plot(RLL_washout(4,:),  'r-')
hold on
plot(RLL_washout(5,:),  'g-')
hold on
plot(RLL_washout(6,:),  'b-')
hold on
plot(RLL_washout(7,:),  'w-')
hold on
plot(RLL_washout(8,:),  'k-')
hold on
plot(RLL_washout(9,:),  'y-')
hold on
plot(RLL_washout(10,:), 'm-')
hold on
plot(RLL_washout(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in RLL for Contrast Wash-out')
print('RLL_washout','-dpng','-r0')

%% Make LUL plot for each patient
figure(11);clf

plot(LUL_washout(1,:),  'k-')
hold on
plot(LUL_washout(2,:),  'm-')
hold on
plot(LUL_washout(3,:),  'c-')
hold on
plot(LUL_washout(4,:),  'r-')
hold on
plot(LUL_washout(5,:),  'g-')
hold on
plot(LUL_washout(6,:),  'b-')
hold on
plot(LUL_washout(7,:),  'w-')
hold on
plot(LUL_washout(8,:),  'k-')
hold on
plot(LUL_washout(9,:),  'y-')
hold on
plot(LUL_washout(10,:), 'm-')
hold on
plot(LUL_washout(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in LUL for Contrast Wash-out')
print('LUL_washout','-dpng','-r0')

%% Make LLL plot for each patient
figure(12);clf

plot(LLL_washout(1,:),  'k-')
hold on
plot(LLL_washout(2,:),  'm-')
hold on
plot(LLL_washout(3,:),  'c-')
hold on
plot(LLL_washout(4,:),  'r-')
hold on
plot(LLL_washout(5,:),  'g-')
hold on
plot(LLL_washout(6,:),  'b-')
hold on
plot(LLL_washout(7,:),  'w-')
hold on
plot(LLL_washout(8,:),  'k-')
hold on
plot(LLL_washout(9,:),  'y-')
hold on
plot(LLL_washout(10,:), 'm-')
hold on
plot(LLL_washout(11,:), 'c-')

legend('002','003','004','005','011','015','016','017','019','021','026')
xlabel('Timestep')
ylabel('Median Lobar Intensity')
title('Plot of F19 Median Lobe Intensity in LUL for Contrast Wash-out')
print('LLL_washout','-dpng','-r0')

%% Change directory home and Print Elapsed Processing Time
cd(home)
toc
close all