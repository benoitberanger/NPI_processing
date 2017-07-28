clear
clc

%% Fetch dirs and subject names

stimpath = [pwd filesep 'raw_stim'];

subjectpath_raw = get_subdir_regex(stimpath, 'NPI');
subjectpath = remove_regex(subjectpath_raw,'_/$');

[~, subject_dir_name] = get_parent_path(subjectpath,1);


%% Create dirs that will receive the cleaned onsets

cleanpath = r_mkdir([pwd filesep 'clean_stim'], subject_dir_name);


%% Clean all tasks

clean_Localizer_stim
clean_MSIT_stim
clean_Morphology_stim
clean_Catex_stim
