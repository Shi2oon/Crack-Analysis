function [ data ] = reshapeData( raw_data )
%PROCESS_DATA Summary of this function goes here
%   Detailed explanation goes here
x = raw_data.x_px;
y = raw_data.y_px;
ux = raw_data.ux_px;
uy = raw_data.uy_px;

xVec = unique(x);
yVec = unique(y);

% nDataPoints = length(x);

%Define grid
[xMap,yMap] = meshgrid(xVec,yVec);
[nRows, nCols] = size(xMap);

% nGridPoints = length(xMap(:));

uxMap = NaN(nRows, nCols); %Initialise
uyMap = NaN(nRows, nCols); %Initialise

for iRow = 1:nRows % loop rows
    for iCol = 1:nCols % loop cols
        xt = xMap(iRow,iCol);
        yt = yMap(iRow,iCol);
        idx = find(and(x==xt,y==yt)); %find linear index of point corresponding to xt,yt;
        if ~isempty(idx)
            uxt = ux(idx);
            uyt = uy(idx);
            uxMap(iRow,iCol) = uxt;
            uyMap(iRow,iCol) = uyt;
        end
    end
end

data.xMap_px = xMap;
data.yMap_px = yMap;
data.uxMap_px = uxMap;
data.uyMap_px = uyMap;
end

