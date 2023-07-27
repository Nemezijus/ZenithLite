# ZenithLite
 A custom wrap-up  code of SVDEnsembles by Han Shuting.

This is a small wrapper module that uses SVDEnsembles repo by Han Shuting and is tailored to our project needs.
In particular the aim of this repo is to bind the visual stimuli to the ensembles detected by SVDEnsembles and show 
whether the detected ensembles represent any subset of visual stimuli or not.

QUICK RUN:

For a quick example test run, load the variables from the exampleData directory and call
[OUT, fig] = findEnsembles(spikeMatrix, ensembleParameters, roiCoordinates, stimuliStruct, stimuliParameters);
in MatLab.


EXPERIMENT STRUCTURE:

Here an experiment or session is called a series of recordings performed in a given time window on a single animal.
Each recording in a session is done with a specific type of visual stimulus being presented. In our experiments 
visual stimuli were gratings of varying contrast values - 'alpha' [0, 5, 8, 20, 30, 50, 100].
During a single recording, visual stimulus started at a specific time moment and stopped shortly afterwards. 
For this code, you need to know at which time frame indexes did the stimulus start and stop. 
Calcium data for every ROI is normalized using DF/F and then converted to inferred spike data. Spike data from all the recordings
of the experiment is stacked next to each other in a row vector. 


PARAMETER FORMAT and EXAMPLE:

An example:
5 recordings were done at 30Hz sampling rate, each for 10s. Visual stimuli were presented between 6-8s. 20 ROIs were identified
and their spike activity was calculated.
The spike raster (spikeMatrix) then would be of dimensions 20 x 1500 (one recording has 300 samples or time frames).
roiCoordinates would be of dimensions 20 x 2, where the first column is x-axis coordinates and the second column is for y-axis cordinates.

stimuliStruct wouuld be a stuct of size 5 with at least two fields:
stimuliStruct(numberOfRec).t - this is a vector with either real time axis of one recording or just indexes of time frames (e.g. [1:300]);
stimuliStruct(numberOfRec).alpha - a scalar value indicating what stimulus was presented during this recording.

stimuliParameters has to indicate the sample indexes when does the visual stimulus start and end and also which field from stimuliStruct to
use as a label for stimuli.
stimuliParameters.stimulusFieldName = 'alpha';
stimuliParameters.stimulusStartAndEndFrames = [180, 240]; %from 6s to 8s.

see provided sample data for realistic example of the needed data format.


