clear
clc

load('/mnt/data/benoit/Protocol/NPI/processing/raw_stim/2015_07_24_NPI_JOUM/JOUM_Morphology_words_MRI_1.mat')

data = DataStruct.TaskData.Record_cell;

audiodata = [];

for event = 1 : size(data,1)
    
    if ~isempty(data{event,3})
        audiodata = [audiodata data{event,3}];
    end
    
end

audiowrite('test.wav',audiodata,DataStruct.Parameters.Record_freq)
