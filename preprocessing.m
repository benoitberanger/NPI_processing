clear
clc

%% Prepare paths and regexp

imgpath = [ pwd filesep 'img'];

subjectpath_raw = get_subdir_regex(imgpath,'NPI');
subjectpath = remove_regex(subjectpath_raw,'_/$');
% suj = get_subdir_regex(chemin);
%to see the content
char(subjectpath_raw)
char(subjectpath)

%functional and anatomic subdir
par.dfonc_reg              = 'EP2D.*[esrTX12]$';
par.dfonc_reg_oposit_phase = 'EP2D.*[esrTX12]_AP$';
par.danat_reg='UNI_Images$';

%for the preprocessing : Volume selecytion
par.anat_file_reg  = '^s.*nii'; %le nom generique du volume pour l'anat
par.file_reg  = '^f.*nii'; %le nom generique du volume pour les fonctionel

par.display=0;
par.run=1;


%% Get files paths

dfonc = get_subdir_regex_multi(subjectpath,par.dfonc_reg)%  ; char(dfonc{:})
dfonc_op = get_subdir_regex_multi(subjectpath,par.dfonc_reg_oposit_phase)% ; char(dfonc_op{:})
dfoncall = get_subdir_regex_multi(subjectpath,{par.dfonc_reg,par.dfonc_reg_oposit_phase })% ; char(dfoncall{:})
anat = get_subdir_regex_one(subjectpath,par.danat_reg)% ; char(anat) %should be no warning


%% Segment anat

%anat segment
% anat = get_subdir_regex(suj,par.danat_reg)
fanat = get_subdir_regex_files(anat,par.anat_file_reg,1)

par.GM   = [0 0 1 0]; % Unmodulated / modulated / native_space dartel / import
par.WM   = [0 0 1 0];
j_segment = job_do_segment(fanat,par)

%apply normalize on anat
fy = get_subdir_regex_files(anat,'^y',1)
fanat = get_subdir_regex_files(anat,'^ms',1)
j_apply_normalise=job_apply_normalize(fy,fanat,par)


%% Brain extract

ff=get_subdir_regex_files(anat,'^c[123]',3);
fo=addsuffixtofilenames(anat,'/mask_brain');
do_fsl_add(ff,fo)
fm=get_subdir_regex_files(anat,'^mask_b',1); fanat=get_subdir_regex_files(anat,'^s.*nii',1);
fo = addprefixtofilenames(fanat,'brain_');
do_fsl_mult(concat_cell(fm,fanat),fo);


%% Preprocess fMRI runs

%realign and reslice
par.file_reg = '^f.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice = job_realign(dfonc,par)

%realign and reslice opposite phase
par.file_reg = '^f.*nii'; par.type = 'estimate_and_reslice';
j_realign_reslice_op = job_realign(dfonc_op,par)

%topup and unwarp
par.file_reg = {'^rf.*nii'}; par.sge=0;
do_topup_unwarp_4D(dfoncall,par)

%coregister mean fonc on brain_anat
% fanat = get_subdir_regex_files(anat,'^s.*nii',1) % raw anat
% fanat = unzip_volume(fanat);
% fanat = get_subdir_regex_files(anat,'^ms.*nii$',1) % raw anat + signal bias correction
fanat = get_subdir_regex_files(anat,'^brain_s.*nii$',1) % brain mask applied (not perfect, there are holes in the mask)

par.type = 'estimate';
for nbs=1:length(subjectpath)
    fmean(nbs) = get_subdir_regex_files(dfonc{nbs}(1),'^utmeanf');
end

fo = get_subdir_regex_files(dfonc,'^utrf.*nii',1)
j_coregister=job_coregister(fmean,fanat,fo,par)

%apply normalize
fy = get_subdir_regex_files(anat,'^y',1)
j_apply_normalize=job_apply_normalize(fy,fo,par)

%smooth the data
ffonc = get_subdir_regex_files(dfonc,'^wutrf.*nii')
par.smooth = [8 8 8];
j_smooth=job_smooth(ffonc,par)

