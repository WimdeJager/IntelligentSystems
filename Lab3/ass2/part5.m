load('normdist.mat');

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
S2_norm = S2_norm*S2_prior; % Multiplied by P(w2);

syms x
eqt1 = (2/3)*(1/(S1_phat(2)*sqrt(2*pi)))*exp(-(x-S1_phat(1))^2/(2*S1_phat(2))^2);
eqt2 = (1/3)*(1/(S2_phat(2)*sqrt(2*pi)))*exp(-(x-S2_phat(1))^2/(2*S2_phat(2))^2);
solx = double(solve(eqt1==eqt2));
