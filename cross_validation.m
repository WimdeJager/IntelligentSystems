load('data_lvq.mat'); % load data

% Defining some names
data = w5_1;
[example_count, dimension]  = size(data);
class1 = data(1 : example_count/2, :);
class2 = data((example_count/2)+1 : example_count, :);

% Shuffle data set
rand_idxs = randperm(example_count);

% Storing class numbers in data
data(1:50,3)   = 1;
data(51:100,3) = 2;

% Setting values
epoch_max = 100;
step_size = 0.002;
folds = 5;
prototypes = 0;
training_errors = zeros(1,folds);
test_errors = zeros(1,folds);
training_avg = zeros(1,5);
training_stddev = zeros(1,5);
test_avg = zeros(1,5);
test_stddev = zeros(1,5);

for p = 1:5
  % Defining prototypes (x,y,i,j) where x and y are the features from our 
  % input vectors. i is the index from the input and j is class 1 or 2.
  prototype_count = p;
  prototypes = zeros(prototype_count,4);
  for i = 1:folds
    i_start = 20*(i-1) + 1;
    i_end = i_start + 19;
    D_idxs = rand_idxs(i_start : i_end); % D_i_test = D_i
    D_train = data;
    D_train(D_idxs(:), :) = []; % D_i_train = D / D_i
    D_test = data(D_idxs,:);

    [prototypes, training_error, test_error] = ... 
      lvq_1(D_train, D_test, prototype_count*2, step_size, epoch_max);
    training_errors(i) = training_error;
    test_errors(i) = test_error;
  end
  % compute averages and standard deviations
  training_avg(p) = mean(training_errors);
  training_stddev(p) = std(training_errors);
  test_avg(p) = mean(test_errors);
  test_stddev(p) = std(test_errors);
end

figure(1);
errorbar(x, training_avg, training_stddev);

figure(2);
errorbar(x, test_avg, test_stddev);

