load('data_lvq.mat');

% Defining some names
data = w5_1;
[example_count, dimension]  = size(data);
class1 = data(1:example_count/2,:);
class2 = data((example_count/2)+1 : example_count, :);

% Defining prototypes (x,y,i,j) where x and y are the features from our input
% vectors. i is the index from the input and j is class 1 or 2.
prototype_count = 2;
prototypes = zeros(prototype_count,4);

for i = 1:prototype_count
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
    prototypes(i,1) = data(r,1);
    prototypes(i,2) = data(r,2);
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


% Plot examples
close all;
f = figure('visible','on', 'pos',[0 0 1920 1080]); % Plotting examples
scatter(class1(:,1), class1(:,2),'MarkerEdgeColor',[0 0 0], ...
    'MarkerFaceColor',[0 0 0], 'LineWidth', 1.5);
hold on
scatter(class2(:,1), class2(:,2), 'MarkerEdgeColor',[0 0 0], ...
    'MarkerFaceColor',[1 1 1], 'LineWidth',1.5);

% Begin epochs
distances_to_prototypes = zeros(example_count, prototype_count);
epoch_max = 10;
step_size = 0.002;
quant_error = zeros(1,epoch_max);
sum = 0;
for i = 1:epoch_max
    rand_example_idxs = randperm(example_count);
    
    for j = 1:example_count
        if ismember(j,prototypes(:,3)) == 0 % example is not prototype
            example_x = data(rand_example_idxs(j),1);
            example_y = data(rand_example_idxs(j),2);
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
                sum = sum + winner_dist;
            end
        end
    end
    
    figure(f);
    
    class1_prototypes = scatter(prototypes(1:prototype_count/2,1), ...
        prototypes(1:prototype_count/2,2), ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',[0 1 0], ...
        'LineWidth',1.5);
    hold on
    class2_prototypes = scatter(prototypes((prototype_count/2)+1:prototype_count,1), ...
        prototypes((prototype_count/2)+1:prototype_count,2), ...
        'MarkerEdgeColor',[0 0 0], 'MarkerFaceColor',[0 0 1], ...
        'LineWidth',1.5);
    
    title_name = sprintf('LVQ-1 Feature Space: %d epochs elapsed', i);
    title(title_name);
    xlabel('Feature x');
    ylabel('Feature y');
    
    l = legend('location','southoutside', 'Class 1','class 2', 'Class 1 Prototype', 'Class 2 Prototype');
    
    filename = sprintf('%s_%d','epochs',i);
    saveas(f, filename, 'png');
    
    delete(class1_prototypes);
    delete(class2_prototypes);
    
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
filename = sprintf('%s_K=%d_tmax=%d', 'HVQ', prototype_count, epoch_max);
saveas(f2, filename, 'png');
