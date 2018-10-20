load('data_lvq.mat');

[example_count, dimension]  = size(w5_1);

% Getting prototypes
num_prototypes = 2; % Number of prototypes
prototypes = zeros(num_prototypes,3); % 3rd columns records idx in dataset
for i = 1:num_prototypes
	r = randi(example_count);
	if i ~= 1
		while ismember(r,prototypes(:,3)) ~= 0
			r = randi(example_count);
		end
	end
	prototypes(i,1) = w5_1(r,1);
	prototypes(i,2) = w5_1(r,2);
	prototypes(i,3) = r;
end

% Begin epochs
% distances has extra column for idxs used in computation
close all;
f = figure('visible','on'); % Plotting examples
scatter(w5_1(1:50,1), w5_1(1:50,2), ...
              'MarkerEdgeColor',[0 .5 .5], ...
              'MarkerFaceColor',[0 .7 .7], ...
              'LineWidth',1.5);
scatter(w5_1(50:100,1), w5_1(50:100,2), ...
              'MarkerEdgeColor',[0 .2 .2], ...
              'MarkerFaceColor',[0 .4 .4], ...
              'LineWidth',1.5);
hold on

distances = zeros(example_count, num_prototypes);
distance_count = 0;
epoch_max = 10;
step_size = 0.002;
quant_error = zeros(1,epoch_max);
sum = 0;
for i = 1:epoch_max
	rand_set1_idxs = randperm(example_count);
	for j = 1:example_count
		if ismember(j,prototypes(:,3)) == 0 % example is not prototype
			example_x = w5_1(rand_set1_idxs(j),1);
			example_y = w5_1(rand_set1_idxs(j),2);
			for k = 1:num_prototypes
				prototype_x = prototypes(k,1);
				prototype_y = prototypes(k,2);
				x_diff = prototype_x - example_x;
				y_diff = prototype_y - example_y;
				euclidian_dist = sqrt(x_diff^2 + y_diff^2);
				distances(j, k) = euclidian_dist;
      end
      [winner_dist, winner_idx] = min(distances(j,:));
      winner_x = prototypes(winner_idx, 1);
      winner_y = prototypes(winner_idx, 2);
      prototypes(winner_idx,1:2) = ...
        new_prototype(step_size, winner_x, winner_y, example_x, example_y);
      sum = sum + winner_dist;
    end
  end

	% Plot epoch
  if (1) 
    figure(1);
    new_pos = scatter(prototypes(:,1), prototypes(:,2), 'MarkerEdgeColor',[0 .5 .5],...
                'MarkerFaceColor',[1 0 0],...
                'LineWidth',1.5,...
                'DisplayName', 'prototype');
    filename = sprintf('%s_%d','epochs',i);
    saveas(f, filename, 'png');
    delete(new_pos);
    title('Data points');
    xlabel('feature x');
    ylabel('feature y');
  end
  
  % Collect quantization error
  quant_error(i) = sum;
  sum = 0;
end

% Plot quantization error
f2 = figure('visible','on'); % Plotting examples
hold on
plot(quant_error);
title('Quantization error for epochs');
xlabel('Epoch number');
ylabel('Quantization error (H_{VQ})');
filename = sprintf('%s_K=%d_tmax=%d', 'HVQ', num_prototypes, epoch_max);
saveas(f2, filename, 'png');
