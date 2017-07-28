clear
clc

%% Prepare paths and regexp

imgpath = [ pwd filesep 'img'];

subjectpath_raw = get_subdir_regex(imgpath,'NPI');
subjectpath = remove_regex(subjectpath_raw,'_/$');

%to see the content
char(subjectpath)

par.display=0;
par.run=1;


%% first level parameters

statdir=r_mkdir(subjectpath,'stat')

par.file_reg = '^swutrf.*nii';
par.TR=2.000;

par.rp = 1; % realignment paramters : movement regressors

par.run = 1;
par.display = 0;

%% Delete previous dirs

par.delete_previous=1;

localizerdir=r_mkdir(statdir,'localizer')
do_delete(localizerdir,0)
localizerdir=r_mkdir(statdir,'localizer')

msitdir=r_mkdir(statdir,'msit')
do_delete(msitdir,0)
msitdir=r_mkdir(statdir,'msit')

morphodir=r_mkdir(statdir,'morpho')
do_delete(morphodir,0)
morphodir=r_mkdir(statdir,'morpho')

catexdir=r_mkdir(statdir,'catex')
do_delete(catexdir,0)
catexdir=r_mkdir(statdir,'catex')


%% All tasks

firstlevel_Localizer
firstlevel_MSIT
firstlevel_Morpho
firstlevel_Catex
