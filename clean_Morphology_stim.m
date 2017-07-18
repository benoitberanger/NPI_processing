clear
clc

%% Fetch dirs and subject names

stimpath = [pwd filesep 'raw_stim'];

subjectpath = get_subdir_regex(stimpath, 'NPI');

[~, subject_dir_name] = get_parent_path(subjectpath,1);

%% Create dirs that will receive the cleaned onsets

cleanpath = r_mkdir([pwd filesep 'clean_stim'], subject_dir_name);

%% Clean

for subj = 1 : length(subjectpath)
    
    nonce_files = get_subdir_regex_files(subjectpath{subj}, 'Morphology_nonce_MRI_1.mat', 1);
    nonce = load(nonce_files{1});
    
    listOfOnsets_nonce = nonce.DataStruct.TaskData.Display_cell;
    
    names = {'null', 'morpho_nonce', 'control_nonce'};
    onsets = cell(size(names));
    durations = cell(size(names));
    
    for idx = 2 : size(listOfOnsets_nonce,1)-1
        switch listOfOnsets_nonce{idx,1}
            case 'condition_NULL_cross'
                onsets{1}    = [onsets{1}    listOfOnsets_nonce{idx  ,2}                          ];
                durations{1} = [durations{1} listOfOnsets_nonce{idx+1,2}-listOfOnsets_nonce{idx,2}];
            case 'condition_0_cross'
                onsets{2}    = [onsets{2}    listOfOnsets_nonce{idx  ,2}                          ];
                durations{2} = [durations{2} listOfOnsets_nonce{idx+1,2}-listOfOnsets_nonce{idx,2}];
            case 'condition_1_cross'
                onsets{3}    = [onsets{3}    listOfOnsets_nonce{idx  ,2}                          ];
                durations{3} = [durations{3} listOfOnsets_nonce{idx+1,2}-listOfOnsets_nonce{idx,2}];
        end
    end
    
    save([cleanpath{subj} 'morpho_nonce.mat'],'names','onsets','durations')
    
end % subj

for subj = 1 : length(subjectpath)
    
    words_files = get_subdir_regex_files(subjectpath{subj}, 'Morphology_words_MRI_1.mat', 1);
    words = load(words_files{1});
    
    listOfOnsets_words = words.DataStruct.TaskData.Display_cell;
    
    names = {'null', 'morpho_nonce', 'control_nonce'};
    onsets = cell(size(names));
    durations = cell(size(names));
    
    for idx = 2 : size(listOfOnsets_words,1)-1
        switch listOfOnsets_words{idx,1}
            case 'condition_NULL_cross'
                onsets{1}    = [onsets{1}    listOfOnsets_words{idx  ,2}                          ];
                durations{1} = [durations{1} listOfOnsets_words{idx+1,2}-listOfOnsets_words{idx,2}];
            case 'condition_0_cross'
                onsets{2}    = [onsets{2}    listOfOnsets_words{idx  ,2}                          ];
                durations{2} = [durations{2} listOfOnsets_words{idx+1,2}-listOfOnsets_words{idx,2}];
            case 'condition_1_cross'
                onsets{3}    = [onsets{3}    listOfOnsets_words{idx  ,2}                          ];
                durations{3} = [durations{3} listOfOnsets_words{idx+1,2}-listOfOnsets_words{idx,2}];
        end
    end
    
    save([cleanpath{subj} 'morpho_words.mat'],'names','onsets','durations')
    
end % subj
