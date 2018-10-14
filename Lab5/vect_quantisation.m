load('w6_1x.mat');
load('w6_1y.mat');
load('w6_1z.mat');

% 3 datasets of 2-dimensional points
set1 = w6_1x;
set2 = w6_1y;
set3 = w6_1z;
example_count = 1000;

% Getting prototypes
num_prototypes = 2 % Number of prototypes
prototypes = zeros(num_prototypes,3); % 3rd columns records idx in dataset
for i = 1:num_prototypes
	r = randi(example_count);
	if i ~= 1
		while ismember(r,prototypes(:,3)) ~= 0
			r = randi(example_count)
		end
	end
	prototypes(i,1) = set1(r,1);
	prototypes(i,2) = set1(r,2);
	prototypes(i,3) = r;
end

% Begin epochs
% distances has extra column for idxs used in computation
distances = zeros(example_count - num_prototypes, num_prototypes + 1);
distance_count = 0;
epoch_max = 1;
for i = 1:epoch_max
	rand_set1_idxs = randperm(example_count);
	for j = 1:example_count
		if ismember(j,prototypes(:,3)) == 0 % example is not prototype
			example_x = set1(rand_set1_idxs(j),1);
			example_y = set1(rand_set1_idxs(j),2);
			distance_count = distance_count + 1;
			distances(distance_count, 3) = rand_set1_idxs(j);
			for k = 1:num_prototypes
				prototype_x = prototypes(k,1);
				prototype_y = prototypes(k,2);
				x_diff = prototype_x-example_x;
				y_diff = prototype_y-example_y;
				euclidian_dist = sqrt(x_diff^2 + y_diff^2);
				distances(distance_count, k) = euclidian_dist;
			end
		end
	end
end
