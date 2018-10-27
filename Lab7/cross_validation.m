load('data_lvq.mat'); % load data

% Defining some names
data = w5_1;
[example_count, dimension]  = size(data);
class1 = data(1 : example_count/2, :);
class2 = data((example_count/2)+1 : example_count, :);

% Defining prototypes (x,y,i,j) where x and y are the features from our 
% input vectors. i is the index from the input and j is class 1 or 2.
prototype_count = 2;
prototypes = zeros(prototype_count,4);

% Shuffle data set
rand_idxs = randperm(example_count);

% Storing class numbers in data
data(1:50,3)   = 1;
data(51:100,3) = 2;

% Setting values
epoch_max = 100;
step_size = 0.002;
prototypes = zeros(prototype_count,4);
training_error = zeros(1,epoch_max);
test_error = zeros(1,epoch_max);

for i = 1:5
  i_start = 20*(i-1) + 1;
  i_end = i_start + 19;
  D_idxs = rand_idxs(i_start : i_end); % D_i_test = D_i
  D_train = data;
  D_train(D_idxs(:), :) = []; % D_i_train = D / D_i
  D_test = data(D_idxs,:);
  
  [prototypes, training_error] = lvq_1(D_train, D_test, prototype_count, step_size, epoch_max);
end

% 4. Perfrom LVQ-1 on D_i_train. The trained prototypes are then tested
% using the test set. During the training we compile the training error and
% after a training we compute the test error.

% 5. For both type of errors we compile an average and standard deviation
% using the errors compiled for each fold.
