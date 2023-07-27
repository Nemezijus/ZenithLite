function stimuli = collectStimuliToMatrix(stimuliStruct, visStimWindow, stimulusFieldName)
% stimuli = collectStimuliToMatrix(stimuliStruct, visStimWindow,...
%                                   stimulusFieldName)
% this function collects stimuli presence across all time frames in the
% given experiment/session. 
% 
% stimuliStruct - a struct containing at least two fields:
%       t - the time axis
%       <custom_name> - an integer representing the stimulus type presented
%           during this recording.
% visStimWindow - a vector of two numbers; the sample index when visual
%   stimulus starts and when it ends [stimStart, stimEnd].
% stimulusFieldName - a string representing the <custom_name> field to be
%   used from stimuliStruct
%
%the output of this function is needed for CRF model as described here 
%https://github.com/hanshuting/graph_ensemble
if nargin < 3
    stimulusFieldName = 'type';
end

fromFrame = visStimWindow(1);
toFrame = visStimWindow(2);

%time axis (t) is used to determine how many samples are in a single 
%measurement unit so that we can determine where are stimuli windows 
%with respect to the spike raster
numberOfFramesInUnit = numel(stimuliStruct(1).t); 
numberOfFrames = numel([stimuliStruct.t]);

uniqueStimuli = unique([stimuliStruct.(stimulusFieldName)]);
uniqueStimuliIndex = 1:numel(uniqueStimuli);
numberOfUnits = numel(stimuliStruct);



stimuli = zeros(numel(uniqueStimuli), numberOfFrames) + -Inf;

for unitIndex = 1:numberOfUnits
    range = [(unitIndex-1)*numberOfFramesInUnit + 1 : unitIndex*numberOfFramesInUnit];
    stimulusIndex = uniqueStimuliIndex(uniqueStimuli == stimuliStruct(unitIndex).(stimulusFieldName)); 
    stimuli(stimulusIndex, range(fromFrame:toFrame)) = 1;
    
end