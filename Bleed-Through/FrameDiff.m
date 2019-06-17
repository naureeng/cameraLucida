% Depth v Slope across frames

tsStack1 = TIFFStack('2019-05-02_5_FR146_zStackMean_G.tif');
tsStack2 = TIFFStack('2019-05-02_5_FR146_zStackMean_R.tif');

tsStack1 = mat2gray(double(tsStack1));
tsStack2 = mat2gray(double(tsStack2));

tic
p = zeros(2,348);
for i = 1:348
    p(:,i) = polyfit(tsStack1(:,:,i),tsStack2(:,:,i),1);
end
toc

x_val = 1:348;
y1_val = p(1,:);
y2_val = p(2,:);
y3_val = p(1,:) + p(2,:);

figure;
scatter(x_val,y1_val,'b','.');
hold on;
scatter(x_val,y2_val,'r','.');
scatter(x_val,y3_val,'g','.');
xlabel('Frame Number [depth]');
ylabel('Slope of Linear Fit [R:G]');
title('Depth v. Slope');
