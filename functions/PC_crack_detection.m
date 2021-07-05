function [ crackLength, visPC ] = PC_crack_detection( data, spacing )
%PC_CRACK_DETECTION Summary of this function goes here
%   Detailed explanation goes here
 
    
    im1 = -data.uyMap_px;
    
    
    % fill in NaNs
    im2 = inpaint_nans(im1,1);
    
    % outlier deletion
    [im3] = OutDel(im2,10,0.2);
    im4 = inpaint_nans(im3,1);
    
    % phase congruency
    PC = phasecongmono(im4, 100, 3, 2.5, 0.55, 2.0);
    
    % crop PC
    %cPC = PC(100:150,:);
    cPC = PC;
    % binarize (threshold) image
    cPC_bin = imbinarize(cPC,0.004); 
    
    % calculate crack length from size of largest region
    cc = bwconncomp(cPC_bin);
    rp = regionprops(cc);
    rp = struct2cell(rp);
    rp = rp';
    rp = sortrows(rp, 1);
    boundingbox = rp{end,3};
    crackLength = boundingbox(1)+boundingbox(3);
    crackLength = crackLength * spacing;
    
%     fprintf('Crack length = %3.0f pixels\n',cl)
    
    visPC.im1 = im1;
    visPC.im2 = im2;
    visPC.im3 = im3;
    visPC.im4 = im4;
    visPC.cPC = cPC;
    visPC.cPC_bin = cPC_bin;
      

end

