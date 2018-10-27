function prototypes = lvq1(training_set, prototype_count, step_size, epoch_max)
% Defining some names
[example_count, dimension]  = size(training_set);
class1 = training_set(1:example_count/2,:);
class2 = training_set((example_count/2)+1 : example_count, :);

% Defining prototypes (x,y,i,j) where x and y are the features from our input
% vectors. i is the index from the input and j is class 1 or 2.
prototypes = zeros(prototype_count,4);
for i = 1:prototype_codataunt
    if i <= prototype_count/2
        r = randi(example_count/2);
    else
        r = randi(example_count/2) + 50;
    end
    if i ~= 1
        while ismember(r,prototypes(:,3)) ~= 0
            if i <= prototype_count/2
                r = randi(example_count/2);
            else
                r = randi(example_count/2) + 50;
            end
        end
    end
    prototypes(i,1) = training_set(r,1);
    prototypes(i,2) = training_set(r,2);
    prototypes(i,3) = r;
    if r <= 50
        prototypes(i,4) = 1 ;
    else
        prototypes(i,4) = 2 ;
    end
end

% Remove prototypes from class variables so we don't plot the prototypes
% 2 times
class1(prototypes(1:prototype_count/2,3),:) = [];
class2(prototypes((prototype_count/2)+1:prototype_count,3)-50,:) = [];

% Begin epochs
distances_to_prototypes = zeros(example_count, prototype_count);
step_size = 0.002;
training_error = zeros(1,epoch_max);
for i = 1:epoch_max
    rand_example_idxs = randperm(example_count);
    training_error_sum = 0;
    
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
            
            [winner_dist, winner_idx] = min(distances_to_prototypes(j,:));
            winner_x = prototypes(winner_idx, 1);
            winner_y = prototypes(winner_idx, 2);
            if ((prototypes(winner_idx,4) == 1) && (j <= 50)) ...
                    || ((prototypes(winner_idx,4) == 2) && (j > 50)) % same class
                prototypes(winner_idx,1:2) = ...
                    new_prototype(step_size, winner_x, winner_y, example_x, example_y);
            else % different class so reflect example point over protoype then move
                training_error_sum = training_error_sum + 1;
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
    
    training_error(i) = training_error_sum;
end
