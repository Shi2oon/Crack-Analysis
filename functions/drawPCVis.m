function [ fig ] = drawPCVis( visPC, iStage,output)
% DRAWPCVIS Summary of this function goes here
% Detailed explanation goes here

%% NB plotted figures here do not have x and y axes scaled by the DIC displacement field spacing.
% Calculated crack length is OK

% plot figures
fig = figure;
% fig.Visible = 'off';

subplot(2,3,1)
imagesc(visPC.im1)
set(gca,'visible','on');
axis image
title('a) Raw Data')
xlabel('x [\mum]');
ylabel('y [\mum]');

subplot(2,3,2)
imagesc(visPC.im2)
set(gca,'visible','on');
axis image
title('b) Fill in NaNs')
set(gca,'xtick',[]);
set(gca,'ytick',[]); 

subplot(2,3,3)
imagesc(visPC.im3)
set(gca,'visible','on');
title('c) Median Filtering')
axis image
set(gca,'xtick',[]);
set(gca,'ytick',[]); 

subplot(2,3,4)
imagesc(visPC.im4)
set(gca,'visible','on');
title('d) Fill in NaNs')
axis image
set(gca,'xtick',[]);
set(gca,'ytick',[]);

subplot(2,3,5)
imagesc(visPC.cPC)
set(gca,'visible','on');
title('e) Phase Congruency')
axis image
set(gca,'xtick',[]);
set(gca,'ytick',[]); 

subplot(2,3,6)
imagesc(visPC.cPC_bin)
set(gca,'visible','on');
title('f) Binarize the Image')
axis image
set(gca,'xtick',[]);
set(gca,'ytick',[]);

set(gcf,'position',[0,0,1950,1000])
saveas(fig,[output '\' num2str(iStage) '.png'])


end

