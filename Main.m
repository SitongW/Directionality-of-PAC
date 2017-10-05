%--------examples of how to use Stimulation functions to build stimulated signals-------
Timelag=-0.02;
[ Signal ] = stimulation( TimeLag );
%--------examples of calculating PAC_CMI using defalt settings-------
range=[3,8;30,50];
srate=1000;
width=10000;
Y=PAC_CMI_MAIN(LFP_data,range,width,srate);

%-------examples of calculating PAC_MI using defalt settings-------
range1=[8:12;9:13]';
range2=[30:99;31:100]';
srate=1000;
width=10000;
bin=18;
fil_mode='eegfilt';
cross='ab';
Y=CFC_entropy_cell(LFP_MEL,range1,range2,width,srate,fil_mode,bin,cross);
