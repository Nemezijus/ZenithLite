function [OUT, fig] = findEnsembles(spikeMatrix, ensembleParameters,...
    roiCoordinates, stimuliStruct, stimuliParameters)

%OUT = findEnsembles (spikeMatrix 
%                   [, ensembleParameters] 
%                   [, roiCoordinates]
%                   [, stimuliStruct] 
%                   [, stimuliParameters]
%                   ) 
%   - a custom wrap up of SVDEnsemble library. Based on toolbox developed 
%       by Han Shuting (https://github.com/hanshuting/SVDEnsemble)
%
% INPUTS:
%   spikeMatrix - a N x T size binary matrix representing a spike raster; 
%      N - number of ROIs, T - number of total time frames
%
%   ensembleParameters - a struct with four fields, containing threshold 
%       values for various stages in ensemble detection. See help file of
%       findSVDEnsemble for more information. The fields are 
%       pks, ticut, jcut, and state_cut.
%
%   roiCoordinates - a column vector of size NRoi x 2 with x,y coordinates
%       of each ROI (1st and 2nd columns respectively). NRoi is the 
%       number of ROIs. Used only for visualization purposes.
%
%   stimuliStruct - a struct that contains data about stimuli used in the 
%       given experiment/session. The size of the struct should equal the
%       number of measurements/recordings for this session.
%       At least two fields are required to be in this struct:
%       t - a vector of time axis values or sample indices for each recording.
%       <custom name> - a single integer representing what stimulus was
%       used during this recording. By default this field is called 'alpha'
%       in the code (representing transparency values). See accompanying
%       example struct to see the expected structure of this struct.
%
%   stimuliParameters - a struct with two fields in it:
%       stimulusFieldName - a string, indicating what field from
%       stimuliStruct contains the labels for type of stimuli used in each
%       recording.
%       stimulusStartAndEndFrames - a vector of two values indicating in
%       sample indexes when does the stimulus start and end, respectively.
%
% OUTPUTS:
%   OUT - a struct with four fields, containing results from ensemble
%       detection:
%       coreSVD - a cell array with indices of core ROIs forming each
%       ensemble.
%       statePeaksFull - a vector of the same length (T) as the spikeMatrix
%       where each time frame is labelled by the ensemble ID that it is
%       attributed to. 0 indicates that the time frame is not associated
%       with any ensemble.
%       stimEnsembles - a struct which contains stimuli ids for every
%       detected ensemble. -Inf indicates no stimulus time frame.
%       parameters - a struct with the same contents as ensembleParameters.
%       If ensmebleParameters was not specified then the code estimated
%       them automatically.
%
%   fig - a figure handle to the histogram plot.
%
%



coreSVD = [];
stimEnsembles = [];
OUT = [];
fig = [];

hasStimuliData = 1;
%distributing defaults based on number of inputs provided
if nargin < 5
    stimuliParameters = generateDefaultStimuliParameterStruct();
end

if nargin < 4 %no stimuli present
    hasStimuliData = 0;
    stimuliParameters = [];
end

if nargin < 3 | isempty(roiCoordinates) %no coordinates, create a rectangular grid
    roiCoordinates = generateArtificialCoordinates(numel(spikeMatrix(:,1)));
end
sizeOfRoiCoordinates = size(roiCoordinates);

%if coordinates are row vectors we transpose them to be into column vectors
if sizeOfRoiCoordinates(1) < sizeOfRoiCoordinates(2)
    roiCoordinates = roiCoordinates';
end

if nargin < 2
    ensembleParameters = struct;
end

if nargin == 0
    error('Spike raster was not provided!');
end


[coreSVD, statePeaksFull, parameters] = findSVDensemble(spikeMatrix, roiCoordinates,...
    ensembleParameters);


numberOfEnsembles = numel(coreSVD);

if numberOfEnsembles == 0
    msgbox('No Ensembles Found! Terminating!');
    OUT = [];
    return;
end


%if stimulus struct is present, 
if hasStimuliData
    noStimIndicator = -Inf; %this labels all time samples that are not part of visual stimuli 
    uniqueStimuli = unique([stimuliStruct.(stimuliParameters.stimulusFieldName)]);
    allIndicators = [noStimIndicator, uniqueStimuli];
    allIndicatorLabels = sprintfc('%d' ,allIndicators);
    
    stimuli = collectStimuliToMatrix(stimuliStruct,...
        stimuliParameters.stimulusStartAndEndFrames,...
        stimuliParameters.stimulusFieldName);
    

    stimuliVector = ones(size(stimuli(1,:))) .* noStimIndicator;
    
    for stimulusIndex = 1:numel(uniqueStimuli)
        stimuliVector(stimuli(stimulusIndex,:)==1) = uniqueStimuli(stimulusIndex);
    end
    
    for ensembleIndex = 1:numberOfEnsembles
        currStimuli = stimuliVector(statePeaksFull == ensembleIndex);
        stimEnsembles(ensembleIndex).stims = currStimuli;
    end
    
    fig = plotSVDEnsemblesWithAssociatedStimuli(stimEnsembles, allIndicators, allIndicatorLabels);
end

OUT.coreSVD = coreSVD;
OUT.statePeaksFull = statePeaksFull;
OUT.stimEnsembles = stimEnsembles;
OUT.parameters = parameters;
