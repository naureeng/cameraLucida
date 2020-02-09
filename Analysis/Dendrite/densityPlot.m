% DENSITYPLOT 	average density plot of all neurons 
% 
% See also: DENSITYNEURON
% 2020 N Ghani and LF Rossi

%% step 1: density plots
load('neuronData.mat'); % load data
n = length(neuronData);
densityNeuron( neuronData, 1:n ); % non-shuffle in visual space [AE]
print( 'AE' , '-dpng' );
densityNeuron( neuronData, randperm(n) ); % shuffle in visual space [AE]
print( 'AE_shuffle', '-dpng' );

%% step 2: histogram for non-shuffle in visual space [AE]
[histCnts, avgAng, cVar]     = densityHist( neuronData, 1:n );
print( 'AE_hist', '-dpng');

%% step 3: histogram for shuffle in visual space [AE]
n_shuffles = 100; % number of shuffles
histCnts_s = cell(n_shuffles, 1);
avgAng_s   = cell(n_shuffles, 1);
cVar_s     = cell(n_shuffles, 1);
for i = 1 : n_shuffles
    [histCnts_s{i,1}, avgAng_s{i,1}, cVar_s{i,1}] = densityHist( neuronData, randperm(n) );
end

shuffleData.histCnts_s = histCnts_s; shuffleData.avgAng_s = avgAng_s; shuffleData.cVar_s = cVar_s;
save('shuffleData','shuffleData');

%% step 4: plot of unshuffled v. shuffled circular variance in visual space [AE]
figure; 
hist( cell2mat(cVar_s), 20);
hold on;
xline( cVar, '--r', 'LineWidth', 2);
xlim([0.3 0.5]);
set(gca, 'fontname', 'Te X Gyre Heros');
xlabel('Circular Variance');
ylabel('Counts');
legend('unshuffled', 'shuffled');

