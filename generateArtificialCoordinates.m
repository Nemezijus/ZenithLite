function coords = generateArtificialCoordinates(nRoi)
% coords = generateArtificialCoordinates(nRoi) - a function
% used by findSVDensembles code, when real coordinates of ROIs are not 
% available. Produces artificial coordinates on a grid. nRoi - number of
% ROIs.

nPerEdge = ceil(sqrt(nRoi));
counter = 1;
for irow = 1:nPerEdge
    for icol = 1:nPerEdge
        coords(counter,1) = icol;
        coords(counter, 2) = irow;
        counter = counter+1;
    end
end

coords = coords(1:nRoi,:);