%% Get files paths

dfonc_catex = get_subdir_regex_multi(subjectpath,'CATEX$') % ; char(dfonc{:})


%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

catex_onsetfile = get_subdir_regex_files(cleanpath,'catex',1)


%% Specify model

j = job_first_level_specify(dfonc_catex,catexdir,catex_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(catexdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : Null'
'main effect : LE'
'main effect : HE'
'LE - Null'
'Null - LE'
'HE - Null'
'Null - HE'
'LE - HE'
'HE - LE'

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
