for subj = 1 : length(subjectpath)
    
    fprintf('LOCALIZER processing : %s\n', subjectpath{subj});
    
    localizer_files = get_subdir_regex_files(subjectpath{subj}, 'Localizer_MRI_\d.mat$', 1);
    loca = load(localizer_files{1});
    
    listOfOnsets = loca.DataStruct.TaskData.Display_cell;
    
    names = {'rest', 'sentence', 'psedo_sentence'};
    onsets = cell(size(names));
    durations = cell(size(names));
    
    prev_name = '';
    prev_target = 1;
    duration_current_event = [];
    
    for idx = 2 : length(listOfOnsets)-1
        switch listOfOnsets{idx,1}
            case 'rest'
                target = 1;
            case 'sentence'
                target = 2;
            case 'psedo_sentence'
                target = 3;
        end
        
        if strcmp(prev_name,listOfOnsets{idx,1})
            duration_current_event = duration_current_event + listOfOnsets{idx+1,2} - listOfOnsets{idx,2};
        else
            durations{prev_target} = [durations{prev_target} duration_current_event];
            
            onsets{target} = [onsets{target} listOfOnsets{idx,2}];
            
            duration_current_event = listOfOnsets{idx+1,2} - listOfOnsets{idx,2};
            
        end
        prev_name = listOfOnsets{idx,1};
        prev_target = target;
    end
    
    % Last 'rest' is special
    durations{1} = [durations{1} listOfOnsets{idx+1,2}-listOfOnsets{idx,2}];
    
    save([cleanpath{subj} 'localizer.mat'],'names','onsets','durations')
    
end % subj
