% load the data
load('lab1_1.mat');

% draw histograms
figure(1);
h = axes(); hold(h,'on');
title('Histogram of heights of men (blue) and women (red)');
xlabel('height (cm)');
ylabel('number of people');
histogram(h,length_men);
histogram(h,length_women);

% draw the decision criterion at 178 cms.
line([178.5, 178.5], ylim, 'LineWidth', 2, 'Color', 'r');