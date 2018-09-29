load('normdist.mat')

phat = mle(S1);
m = mean(S1);
s = std(S1);
norm = normpdf(S1,m,s);

figure;
plot(S1, norm);
