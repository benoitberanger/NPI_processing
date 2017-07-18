clear
clc

%% Prepare paths and regexp

imgpath = [ pwd filesep 'img'];

subjectpath = get_subdir_regex(imgpath,'NPI');
% suj = get_subdir_regex(chemin);
%to see the content
char(subjectpath)

par.display=0;
par.run=1;


%% Get files paths

dfonc_msit = get_subdir_regex_multi(subjectpath,'MSIT$') % ; char(dfonc{:})

%% Fetch onset .mat file

[~, subject_dir_name] = get_parent_path(subjectpath);
cleanpath = get_subdir_regex([pwd filesep 'clean_stim'], subject_dir_name);

msit_onsetfile = get_subdir_regex_files(cleanpath,'msit',1)


%% first level

statdir=r_mkdir(subjectpath,'stat')
msitdir=r_mkdir(statdir,'msit')
do_delete(msitdir,0)
msitdir=r_mkdir(statdir,'msit')

par.file_reg = '^sutrf.*nii';

par.TR=2.000;
par.delete_previous=1;


%% Specify model

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

j = job_first_level_specify(dfonc_msit,msitdir,msit_onsetfile,par)


%% Estimate model

fspm = get_subdir_regex_files(msitdir,'SPM',1)
j_estimate = job_first_level_estimate(fspm,par)


%% Define contrast: all runs

contrast.names = {
    
'main effect : Cross'
'main effect : C0'
'main effect : C1'
'C0 - Cross'
'Cross - C0'
'C1 - Cross'
'Cross - C1'
'C0 - C1'
'C1 - C0'

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

par.run = 1;
par.display = 0;

par.sessrep = 'none';
j_contrast_rep = job_first_level_contrast(fspm,contrast,par)
par.delete_previous=0;

