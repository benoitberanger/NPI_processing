clear
clc

%% Fetch dirs and subject names

stimpath = [pwd filesep 'raw_stim'];

subjectpath_raw = get_subdir_regex(stimpath, 'NPI');
subjectpath = remove_regex(subjectpath_raw,'_/$');

[~, subject_dir_name] = get_parent_path(subjectpath,1);

%% Create dirs that will receive the cleaned onsets

cleanpath = r_mkdir([pwd filesep 'clean_stim'], subject_dir_name);

%% Clean

for subj = 1 : length(subjectpath)
    
    fprintf('MSIT processing : %s\n', subjectpath{subj});
    
    msit_files = get_subdir_regex_files(subjectpath{subj}, 'MSIT_MRI_\d.mat$', 1);
    msit = load(msit_files{1});
    
    listOfOnsets = msit.DataStruct.TaskData.Display_cell;
    to_delete = regexp( listOfOnsets(:,1), 'micro_rest' );
    to_delete = ~cell2mat(cellfun(@isempty,to_delete,'UniformOutput',0));
    to_delete = find(to_delete);
    listOfOnsets(to_delete,:) = [];
    
    names = {'cross', 'C0', 'C1'};
    onsets = cell(size(names));
    durations = cell(size(names));
    
    prev_name = '';
    prev_target = 1;
    duration_current_event = [];
    
    for idx = 2 : length(listOfOnsets)-1
        switch listOfOnsets{idx,1}
            case names{1}
                target = 1;
            case names{2}
                target = 2;
            case names{3}
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
    
    save([cleanpath{subj} 'msit.mat'],'names','onsets','durations')
    
end % subj
