%% Get files paths

dfonc_morpho = get_subdir_regex_multi(subjectpath,'Morpho_1$|Morpho_2$|Morpho_nonce$|Morpho_words$') % ; char(dfonc{:})


%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

morpho_onsetfile = get_subdir_regex_files(cleanpath,'morpho',2)


%% Specify model

j = job_first_level_specify(dfonc_morpho,morphodir,morpho_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(morphodir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

rpVect       = zeros(1,6);
contrastVect = zeros(1,3);

contrast.names = {
    
'nonce : main effect : null'
'nonce : main effect : morpho'
'nonce : main effect : control'
'nonce : morpho - null'
'nonce : null - morpho'
'nonce : control - null'
'nonce : null - control'
'nonce : morpho - control'
'nonce : control - morpho'

'words : main effect : null'
'words : main effect : morpho'
'words : main effect : control'
'words : morpho - null'
'words : null - morpho'
'words : control - null'
'words : null - control'
'words : morpho - control'
'words : control - morpho'

'nonce - words : morpho'
'nonce - words : control'

}';
contrast.values = {
    [ 1 0 0 rpVect contrastVect rpVect ]
    [ 0 1 0 rpVect contrastVect rpVect ]
    [ 0 0 1 rpVect contrastVect rpVect ]
    [ -1 1 0 rpVect contrastVect rpVect ]
    [ 1 -1 0 rpVect contrastVect rpVect ]
    [ -1 0 1 rpVect contrastVect rpVect ]
    [ 1 0 -1 rpVect contrastVect rpVect ]
    [ 0 1 -1 rpVect contrastVect rpVect ]
    [ 0 -1 1 rpVect contrastVect rpVect ]
    
    [ contrastVect rpVect 1 0 0 rpVect ]
    [ contrastVect rpVect 0 1 0 rpVect ]
    [ contrastVect rpVect 0 0 1 rpVect ]
    [ contrastVect rpVect -1 1 0 rpVect ]
    [ contrastVect rpVect 1 -1 0 rpVect ]
    [ contrastVect rpVect -1 0 1 rpVect ]
    [ contrastVect rpVect 1 0 -1 rpVect ]
    [ contrastVect rpVect 0 1 -1 rpVect ]
    [ contrastVect rpVect 0 -1 1 rpVect ]
    
    [ 0 1 0 rpVect 0 -1 0 rpVect ]
    [ 0 0 1 rpVect 0 0 -1 rpVect ]
    
    }';
contrast.types = cat(1,repmat({'T'},[1 length(contrast.names)]));

par.delete_previous=1;


%% Estimate contrast : all runs

par.sessrep = 'none';
j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
par.delete_previous=0;
