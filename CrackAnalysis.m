%% 0.0 Preparation
clear; clc; close all; warning ('off')
% format compact
% set(0,'DefaultFigureWindowStyle','docked')

%%Input data
% where your saved your data
inDir = [pwd '\Example'];
pixel_size = 0.54; % calibration [um/pixel]
overlap = 75; % [%]
subset_size = 32;
cml_cycles = [105,201,299,401,500,749,1000,1249,1500,1750,2000];
set(0,'defaultAxesFontSize',25)

addpath(genpath(pwd));  
fprintf('[ ] Running %s ...\n',mfilename)

%% 0.1 User inputs
output=[inDir '\output']; mkdir(output)

%% 2.0 Read input data
filelist = dir([inDir '\*.dat']);
nStages = size(filelist,1);

%Read DIC data from text files
rawDICData = cell(1,nStages);
textprogressbar('Reading DIC data from text files: ')
for iStage = 1:nStages
    tmp = importdata(fullfile(filelist(iStage).folder, filelist(iStage).name));
    rawDICData{iStage}.x_px = tmp.data(:,1);
    rawDICData{iStage}.y_px = tmp.data(:,2);
    rawDICData{iStage}.ux_px = tmp.data(:,3);
    rawDICData{iStage}.uy_px = tmp.data(:,4);
    textprogressbar((iStage / nStages) * 100)
end
textprogressbar('done')


%% 3.0 Processing steps...
%Reshape scattered data onto regular grid.
%Missing data points contain NaNs

DICData = cell(1,nStages);
textprogressbar('Reshaping Scattered DIC Data onto grid: ')
for iStage = 1:nStages
    DICData{iStage} = reshapeData(rawDICData{iStage});
    textprogressbar((iStage / nStages) * 100)
end
textprogressbar('done')

%PC crack detection


spacing = (1-0.01*overlap)*subset_size;

cracklength = zeros(1,nStages);
visPC = cell(1,nStages);
textprogressbar('Phase Congruency Crack Detection: ')
for iStage = 1:nStages
    [cracklength(iStage), visPC{iStage}] = PC_crack_detection(DICData{iStage}, spacing);
    textprogressbar((iStage / nStages) * 100)
end
textprogressbar('done')

% save('PC_results.mat','cracklength')


%% 4.0 Visualisation

%Drawing PC Method Figures
textprogressbar('Drawing PC Method Figures: ')
for iStage = 1:nStages
    figPCMethod(iStage) = drawPCVis( visPC{iStage}, iStage,output);
    textprogressbar((iStage / nStages) * 100)
end
textprogressbar('done')

%Plot Crack Advance
% load('PC_results.mat')
close all
plot(cml_cycles,cracklength,'x','Color','k','MarkerSize',10)
xlabel('Number of Cycles'); ylabel('Crack Length (pixels)')
saveas(gcf,[output '\PC crack advance.png'])

cracklength_um = cracklength * pixel_size;
crack_advance_um = cracklength_um - ones(size(cracklength_um))*cracklength_um(1);
plot(cml_cycles,crack_advance_um,'x','Color','k','MarkerSize',10)
ylabel('Crack Advance (\mum)'); xlabel('Number of Cycles')
saveas(gcf,[output '\PC crack advance um.png'])

Table = table(cml_cycles(:), crack_advance_um(:),...
    'VariableNames',{'Cycles','Crack_Advance_um'});
output = fullfile(output,'Crack location.xlsx');
writetable(Table, output);

fprintf('[+] %s complete\n',mfilename)
