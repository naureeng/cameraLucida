% BLEED_CORRECT corrects bleed-through of green channel into red channel
%
% Dependencies:
% TIFFStack [by Dylan Muir]
% saveFrames [by Cortex Lab]
% multpolyfit [by Matt Tearle]

tsStack1 = TIFFStack('2019-05-02_5_FR146_zStackMean_G.tif');
tsStack2 = TIFFStack('2019-05-02_5_FR146_zStackMean_R.tif');

tsStack1 = mat2gray(double(tsStack1));
tsStack2 = mat2gray(double(tsStack2));

[p,~] = multpolyfit(tsStack1,tsStack2,1);
p1 = p(1,:);
R_corr = tsStack2 - polyval(p1, tsStack1);

R_corr = mat2gray(R_corr);

saveFrames(uint16(R_corr*2.^16-1),'R_corr.tif');

