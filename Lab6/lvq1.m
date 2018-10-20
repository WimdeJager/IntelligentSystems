load('data_lvq.mat');

data = w5_1;
[example_count, dimension]  = size(data);
class1 = data(1:example_count/2,:);
class2 = data((example_count/2)+1 : example_count, :);
class1_count = example_count/2;
class2_count = class1_count;

% Defining prototypes
prototypes_per_class = 2; % Number of prototypes
class1_prototypes = zeros(prototypes_per_class,3); % 3rd columns records idx in dataset
class2_prototypes = zeros(prototypes_per_class,3); % 3rd columns records idx in dataset

for i = 1:prototypes_per_class % Define class1 prototypes
	r = randi(prototypes_per_class);
	if i ~= 1
		while ismember(r,class1_prototypes(:,3)) ~= 0
	    r = randi(prototypes_per_class);
		end
	end
	class1_prototypes(i,1) = class1(r,1);
	class1_prototypes(i,2) = class1(r,2);
	class1_prototypes(i,3) = r;
end

for i = 1:prototypes_per_class % Define class2 prototypes
	r = randi(prototypes_per_class);
	if i ~= 1
		while ismember(r,class2_prototypes(:,3)) ~= 0
	    r = randi(prototypes_per_class);
		end
	end
	class2_prototypes(i,1) = class2(r,1);
	class2_prototypes(i,2) = class2(r,2);
	class2_prototypes(i,3) = r;
end

% Begin epochs
% distances has extra column for idxs used in computation
close all;
f = figure('visible','on'); % Plotting examples
colors = zeros(100,3);
colors(1:50,1)   = 0; colors(1:50,2)   = 0; colors(1:50,3)   = 1; % set first half to blue
colors(50:100,1) = 1; colors(50:100,2) = 0; colors(50:100,3) = 0; % set second half to red
scatter(w5_1(:,1), w5_1(:,2), 40, colors, 'filled');
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
    new_pos = scatter(prototypes(:,1), prototypes(:,2), ...
                'MarkerFaceColor',[0 1 0], ...
                'LineWidth',1.5);
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