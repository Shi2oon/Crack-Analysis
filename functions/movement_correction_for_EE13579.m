clear; clc; close all;
% movement_correction.m

% load tif files
dirx='X:\EE 13579 Diamond Light Source\Diamond EE 13579\Cycling\0. Raw\Pictures';
Over_path = fullfile(dirx,'\Corrected_pictures'); mkdir(Over_path);
srcFiles = dir([dirx,'\*.tif']);
im = cell(1,length(srcFiles));
for i = 1: length(srcFiles)
    filename = strcat(srcFiles(i).folder,'\',srcFiles(i).name);
    im{i} = imread(filename,'tif');
end

r = int16(1:size(im{1},1));
c = int16(1:size(im{1},2));

for i = 1:length(im)
    % peform cross-correlation
    f = im{1};
    g = im{i};
    upscale_factor = 1; % don't want subpixel correlation
    [output, Greg] = dftregistration(fft2(f),fft2(g),upscale_factor);
    row_shift = int16(output(3));
    col_shift = int16(output(4));
    r_XC{i} = r+row_shift;
    c_XC{i} = c+col_shift;
    
end

for i = 1:length(im)
    imagesc(c_XC{i},r_XC{i},im{i})
    pyxe_D_path = [Over_path '\' srcFiles(i).name '.png'];
    saveas(gcf,pyxe_D_path)
    end
    
% make new images
for i = 1:length(im)
    c_select = find(and(c_XC{i}<2250,c_XC{i}>10));
    r_select = find(and(r_XC{i}<1800,r_XC{i}>0));

    im_new{i} = im{i}(min(r_select):max(r_select), min(c_select):max(c_select));
    r_new{i} = int16(1:size(im_new{1},1));
    c_new{i} = int16(1:size(im_new{1},2));
end

% plot images
for i = 1:length(im)
    figure(i)
    imagesc(c_new{i},r_new{i},im_new{i})
    im_new_filename = [Over_path '\' srcFiles(i).name];
    imwrite(im_new{i},im_new_filename);
    close(figure(i))
end