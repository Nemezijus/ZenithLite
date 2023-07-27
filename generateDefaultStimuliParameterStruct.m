function stimuliParameters = generateDefaultStimuliParameterStruct
% stimuliParameters = generateDefaultStimuliParameterStruct - 
% makes a default stimuli parameter struct based on our group's experiments
% It is only generated if the struct is not provided by the user for the
% main function findEnsembles.

stimuliParameters.stimulusFieldName = 'type';
stimuliParameters.stimulusStartAndEndFrames = [47 87];

