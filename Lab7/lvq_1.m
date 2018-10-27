function [prototypes, training_error, test_error] = lvq_1(training_set, test_set, prototype_count, step_size, epoch_max)
% Defining some names
[example_count, ~] = size(training_set);
class1_bools = training_set(:,3) == 1;
class2_bools = training_set(:,3) == 2;
class1 = training_set(class1_bools, :);
class2 = training_set(class2_bools, :);
[class1_size, ~] = size(class1);
[class2_size, ~] = size(class2);

% Defining prototypes (x,y,i,j) where x and y are the features from our input
% vectors. i is the index from the input and j is class 1 or 2.
prototypes = zeros(prototype_count,4);
for i = 1:prototype_count
	if i <= prototype_count/2
    r = randi(class1_size);
  else
    r = randi(class2_size) + class1_size;
  end
	if i ~= 1
    while ismember(r,prototypes(:,3)) ~= 0
      if i <= class1_size
        r = randi(class1_size);
      else
        r = randi(class2_size) + class1_size;
      end
    end
  end
	prototypes(i,1) = training_set(r,1);
	prototypes(i,2) = training_set(r,2);
	prototypes(i,3) = r;
    
	if i <= prototype_count/2
    prototypes(i,4) = 1 ;
  else
    prototypes(i,4) = 2 ;
	end
end


% Remove prototypes from class variables so we don't plot the prototypes
% 2 times
class1(prototypes(1:(prototype_count/2),3),:) = [];
class2(prototypes((prototype_count/2)+1:(prototype_count/2),3)-class1_size,:) = [];

% Begin epochs
distances_to_prototypes = zeros(example_count, prototype_count);
for i = 1:epoch_max
	rand_example_idxs = randperm(example_count);
  training_error = 0;
	
	for j = 1:example_count
    if ismember(j,prototypes(:,3)) == 0 % example is not prototype
      example_x = training_set(rand_example_idxs(j),1);
      example_y = training_set(rand_example_idxs(j),2);
      for k = 1:prototype_count
        prototype_x = prototypes(k,1);
        prototype_y = prototypes(k,2);
        x_diff = abs(prototype_x - example_x);
        y_diff = abs(prototype_y - example_y);
        euclidian_dist = sqrt(x_diff^2 + y_diff^2);
        distances_to_prototypes(j, k) = euclidian_dist;
      end
      
      [~, winner_idx] = min(distances_to_prototypes(j,:));
      winner_x = prototypes(winner_idx, 1);
      winner_y = prototypes(winner_idx, 2);
      if ((prototypes(winner_idx,4) == 1) && (j <= 50)) ...
            || ((prototypes(winner_idx,4) == 2) && (j > 50)) % same class
        prototypes(winner_idx,1:2) = ...
        new_prototype(step_size, winner_x, winner_y, example_x, example_y);
      else % different class so reflect example point over protoype then move
        if (j == epoch_max)
          training_error = training_error + 1;
        end
        if example_x > winner_x
          example_x = winner_x - x_diff;
        else
          example_x = winner_x + x_diff;
        end
        
        if example_y > winner_y
          example_y = winner_y - y_diff;
        else
          example_y = winner_y + y_diff;
        end
        prototypes(winner_idx,1:2) = ...
        new_prototype(step_size, winner_x, winner_y, example_x, example_y);
      end
    end
  end
  
  test_error = test_prototypes(test_set, prototypes);
end