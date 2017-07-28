%% Get files paths

dfonc_localizer = get_subdir_regex_multi(subjectpath,'Localizer$') % ; char(dfonc{:})

%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

localizer_onsetfile = get_subdir_regex_files(cleanpath,'localizer',1);


%% Specify model


j = job_first_level_specify(dfonc_localizer,localizerdir,localizer_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(localizerdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : rest'
'main effect : sentence'
'main effect : psedo_sentence'
'sentence - rest'
'rest - sentence'
'psedo_sentence - rest'
'rest - psedo_sentence'
'sentence - psedo_sentence'
'psedo_sentence - sentence'

}';
contrast.values = {
    [ 1 0 0 ]
    [ 0 1 0 ]
    [ 0 0 1 ]
    [ -1 1 0 ]
    [ 1 -1 0 ]
    [ -1 0 1 ]
    [ 1 0 -1 ]
    [ 0 1 -1 ]
    [ 0 -1 1 ]
    }';
contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));

par.delete_previous=1;


%% Estimate contrast : all runs

par.sessrep = 'none';
j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
par.delete_previous=0;

