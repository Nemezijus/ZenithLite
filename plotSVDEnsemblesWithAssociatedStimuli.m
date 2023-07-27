function fig = plotSVDEnsemblesWithAssociatedStimuli(ENS, labels, labelIds)
% fig = plotSVDEnsemblesWithAssociatedStimuli(ENS, labels, labelIds) -
% visualizes how detected ensembles associate with time frames during which
% there was a particular stimulus presented or not. No stimulus time frame
% is indicated as -Inf.

numberOfEnsembles = numel(ENS);

numberOfColumns = ceil(sqrt(numberOfEnsembles));
numberOfRows = ceil(numberOfEnsembles/numberOfColumns);

fig = figure;
set(fig,'units', 'normalized', 'position', [0.0995 0.14 0.754 0.748],...
    'Color','White', 'Tag','stimuli_histograms');
AX = autoaxes(fig, numberOfRows, numberOfColumns,...
    [0.01 0.01 0.01 0.01],[0.05 0.05]);
AX = AX'; %transpose, so that the order is left to right, top to bottom
yl = [];
for ensembleIndex = 1:numberOfEnsembles
    axes(AX(ensembleIndex)); 
    if isstring(labels)
        categoryAxis = categorical(ENS(ensembleIndex).stims, labels);
    else
        categoryAxis = categorical(ENS(ensembleIndex).stims, labels, labelIds);
    end
    h(ensembleIndex) = histogram(categoryAxis);  

    ylabel ('Number of coactivations');
    title(['ensemble #', num2str(ensembleIndex)]);
    yl = [yl, get(gca, 'YLim')];
end

for ensembleIndex = 1:numberOfEnsembles
    axes(AX(ensembleIndex));
    set(gca, 'YLim',[min(yl), max(yl)]);
end

