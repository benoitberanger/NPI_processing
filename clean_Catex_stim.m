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
    
    catex_files = get_subdir_regex_files(subjectpath{subj}, 'LexicalCategorization_MRI_1.mat', 1);
    catex = load(catex_files{1});
    
    listOfOnsets_catex = catex.DataStruct.TaskData.Display_cell;
    
    names = {'null', 'low_executive', 'high_executive'};
    onsets = cell(size(names));
    durations = cell(size(names));
    
    for idx = 2 : size(listOfOnsets_catex,1)-1
        switch listOfOnsets_catex{idx,1}
            case 'condition_NULL_pictures'
                onsets{1}    = [onsets{1}    listOfOnsets_catex{idx  ,2}                          ];
                durations{1} = [durations{1} listOfOnsets_catex{idx+1,2}-listOfOnsets_catex{idx,2}];
            case 'condition_LE_pictures'
                onsets{2}    = [onsets{2}    listOfOnsets_catex{idx  ,2}                          ];
                durations{2} = [durations{2} listOfOnsets_catex{idx+1,2}-listOfOnsets_catex{idx,2}];
            case 'condition_HE_pictures'
                onsets{3}    = [onsets{3}    listOfOnsets_catex{idx  ,2}                          ];
                durations{3} = [durations{3} listOfOnsets_catex{idx+1,2}-listOfOnsets_catex{idx,2}];
        end
    end
    
    save([cleanpath{1} 'catex.mat'],'names','onsets','durations')
    
end % subj