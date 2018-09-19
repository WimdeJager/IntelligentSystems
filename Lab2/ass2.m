load('lab1_2.mat');
data = measurements;

body_height = data(:,1);
hair_length = data(:,2);

x = [0 59];
y = [150 200];

scatter(hair_length, body_height);
hold on
line(x,y);
title('Body Height vs Hair Length');
xlabel('Hair Length (cm)');
ylabel('Body Height (cm)');
