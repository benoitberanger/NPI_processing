for subj = 1 : length(subjectpath)
    
    fprintf('CATEX processing : %s\n', subjectpath{subj});
    
    catex_files = get_subdir_regex_files(subjectpath{subj}, 'LexicalCategorization_MRI_\d.mat$', 1);
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
    
    save([cleanpath{subj} 'catex.mat'],'names','onsets','durations')
    
end % subj
