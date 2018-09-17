% histogram(length_men)

figure(1);
h = axes(); hold(h,'on');
title('Histogram of heights of men (blue) and women (red)');
xlabel('height (cm)');
ylabel('number of people');

histogram(h,length_men);
histogram(h,length_women);

%figure(2);
%histogram(length_men);

%figure(3);
%histogram(length_women);