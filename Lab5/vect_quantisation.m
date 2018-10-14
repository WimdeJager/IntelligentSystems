load('w6_1x.mat');
load('w6_1y.mat');
load('w6_1z.mat');

% 3 datasets of 2-dimensional points
set1 = w6_1x;
set2 = w6_1y;
set3 = w6_1z;
[example_count, dimension]  = size(set1);

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
	prototypes(i,1) = set1(r,1);
	prototypes(i,2) = set1(r,2);
	prototypes(i,3) = r;
end

% Begin epochs
% distances has extra column for idxs used in computation
data = x;
data(prototypes(:,3), :) = [];
f = figure('visible','on');
scatter(data(:,1), data(:,2), 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[0 .7 .7],...
              'LineWidth',1.5);
hold on

distances = zeros(example_count, num_prototypes);
distance_count = 0;
epoch_max = 10;
step_size = 0.1;
for i = 1:epoch_max
	rand_set1_idxs = randperm(example_count);
	for j = 1:example_count
		if ismember(j,prototypes(:,3)) == 0 % example is not prototype
			example_x = set1(rand_set1_idxs(j),1);
			example_y = set1(rand_set1_idxs(j),2);
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
    end
  end

	% Calculate the quantisation error
	q_distances = [0 0];
	sum = 0;
	for i = 1:example_count
		for k = 1:num_prototypes
			example_x = set1(i,1);
			example_y = set1(i,2);
			prototype_x = prototypes(k,1);
			prototype_y = prototypes(k,2);
			x_diff = abs(prototype_x - example_x);
			y_diff = abs(prototype_y - example_y);
			euclidian_dist = sqrt(x_diff^2 + y_diff^2);
			q_distances(k) = euclidian_dist;
		end
		sum = sum + min(q_distances);
	end

	% Plot epoch
	new_pos = scatter(prototypes(:,1), prototypes(:,2), 'MarkerEdgeColor',[0 .5 .5],...
              'MarkerFaceColor',[1 0 0],...
              'LineWidth',1.5);
	filename = sprintf('%s_%d','epochs',i)
	saveas(f, filename, 'png');
	delete(new_pos);
end

