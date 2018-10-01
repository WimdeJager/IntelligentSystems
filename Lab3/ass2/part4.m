load('normdist.mat')

S1 = sort(S1);
S2 = sort(S2);

S1_phat = mle(S1);
S1_a = S1_phat(1) - 4*S1_phat(2);
S1_b = S1_phat(1) + 4*S1_phat(2);
S1_x = [S1_a:1:S1_b];
S1_norm = normpdf(S1_x, S1_phat(1), S1_phat(2));
S1_prior = 2/3;
S1_norm = S1_norm*S1_prior; % Multiplied by P(w1)

S2_phat = mle(S2);
S2_a = S2_phat(1) - 4*S2_phat(2);
S2_b = S2_phat(1) + 4*S2_phat(2);
S2_x = [S2_a:1:S2_b];
S2_norm = normpdf(S2_x, S2_phat(1), S2_phat(2));
S2_prior = 1/3;
S2_norm = S2_norm*S2_prior; % Multiplied by P(w2)

figure;
plot(S1_x, S1_norm, 'b');
hold on
plot(S2_x, S2_norm, 'r');
hold on
plot(S1,0,'bo','MarkerSize',10);
hold on
plot(S2,0,'ro','MarkerSize',10);
hold on
plot(T ,0,'ks','MarkerSize',10);

title('S1, S2 and T Plotted Under p(x\mid w_{1})P(w_{1}) and p(x\mid w_{2})P(w_{2})');
xlabel('S1, S2 and T Values (No Units)');
ylabel('p(x\mid w_{i})P(w_{i})');
