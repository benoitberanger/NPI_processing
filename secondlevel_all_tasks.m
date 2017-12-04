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

%% Exams

examList = {
    
% fmri exam               'group'
'2015_05_15_NPI_Pilote03' 'nc'
'2015_05_15_NPI_Pilote04' 'nc'
'2015_06_16_NPI_AUDH'     'nc'
'2015_06_16_NPI_MORP'     'prehd'
'2015_06_18_NPI_KOCL'     'prehd'
'2015_06_23_NPI_HUGC'     'nc'
'2015_06_24_NPI_MAZL'     'prehd'
'2015_06_30_NPI_BERK'     'nc'
'2015_07_21_NPI_PERP'     'nc'
'2015_07_24_NPI_JOUM'     'nc'
'2015_07_24_NPI_MALC'     'nc'
'2015_07_28_NPI_PEAR'     'prehd'
'2015_07_29_NPI_TROC'     'prehd'
'2015_07_31_NPI_BAIR'     'nc'
'2015_07_31_NPI_BRUS'     'nc'
'2015_07_31_NPI_NICP'     'nc'
'2015_08_03_NPI_BREH'     'nc'
'2015_08_03_NPI_LAMC'     'nc'
'2015_08_03_NPI_MATT'     'nc'
'2015_08_05_NPI_DAVE'     'nc'
'2015_08_10_NPI_COMR'     'nc'
'2015_08_10_NPI_TOUP'     'nc'
'2015_08_26_NPI_AMAM'     'nc'
'2015_08_26_NPI_LATP'     'nc'
'2015_08_28_NPI_SIXJ'     'prehd'
'2015_08_28_NPI_ZOZM'     'nc'
'2015_09_14_NPI_PECE'     'prehd'
'2015_10_28_NPI_BERD'     'prehd'
'2016_01_08_NPI_BELA'     'prehd'
'2016_01_15_NPI_RAMC'     'prehd'
'2016_02_05_NPI_MICV'     'prehd'
'2016_02_19_NPI_MOSC'     'nc'
'2016_03_07_NPI_BRAA'     'nc'
'2016_04_08_NPI_BERE'     'prehd'
'2016_05_27_NPI_DIBS'     'prehd'
'2016_10_21_NPI_KOKP'     'prehd'
'2017_07_07_NPI_BRIA'     'prehd'

};


%% Anova

secondlevel_Localizer
secondlevel_Catex
secondlevel_Morpho
