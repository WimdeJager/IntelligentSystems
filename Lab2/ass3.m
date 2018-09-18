% Compute set S
feature_vector_length = 30;
number_of_samples = 1000;

for i = 1:number_of_samples
    random_person_idx = randi(20);
    if(random_person_idx < 10)
        int_string = strcat('0', int2str(random_person_idx));
    else
        int_string = int2str(random_person_idx);
    end
    
    load(strcat('person', int_string, '.mat'));
    iris_data = iriscode;
    
    random_row_1 = iris_data(randi(20),:);
    random_row_2 = iris_data(randi(20),:);
    
    hamming_distance = 0;
    for j = 1:feature_vector_length
        if random_row_1(j) ~= random_row_2(j)
            hamming_distance = hamming_distance+1;
        end
    end
    
    hamming_distance = hamming_distance/30;
    hamming_data_same_person(i) = hamming_distance;

end

% Compute set D
feature_vector_length = 30;
number_of_samples = 1000;

for i = 1:number_of_samples
    random_person_idx_1 = randi(20);
    random_person_idx_2 = randi(20);

    if(random_person_idx_1 < 10)
        int_string_1 = strcat('0', int2str(random_person_idx_1));
    else
        int_string_1 = int2str(random_person_idx_1);
    end
    
    if(random_person_idx_2 < 10)
        int_string_2 = strcat('0', int2str(random_person_idx_2));
    else
        int_string_2 = int2str(random_person_idx_2);
    end
    
    load(strcat('person', int_string_1, '.mat'));
    iris_data_1 = iriscode;
    load(strcat('person', int_string_2, '.mat'));
    iris_data_2 = iriscode;
    
    random_row_1 = iris_data_1(randi(20),:);
    random_row_2 = iris_data_2(randi(20),:);
    
    hamming_distance = 0;
    for j = 1:feature_vector_length
        if random_row_1(j) ~= random_row_2(j)

            hamming_distance = hamming_distance+1;
        end
    end

    hamming_distance = hamming_distance/30;
    hamming_data_different_people(i) = hamming_distance;
end

S = hamming_data_same_person;
D = hamming_data_different_people;
S_t = transpose(S);
D_t = transpose(D);
SD = horzcat(S_t,D_t);
S_mean = mean(S);
S_variance = var(S);
D_mean = mean(S);
D_variance = var(S);

hist_S = histfit(S);
hold on
hist_D = histfit(D);

hist_S(1).FaceColor = [.2 .2 .2];
hist_S(2).Color = [.2 .2 .2];


hist_D(1).FaceColor = [0 1 1];
hist_D(2).Color = [0 1 1];

title('Histogram for Two Sets of Hamming Distances');
xlabel('Hamming Distance / 30');
ylabel('Number of Occurences');
legend({'Hamming distance for the same person','Normal distribution fitted to the same person category', 'Hamming distance for different people', 'Normal distribution fitted to the different person category'},'Location','northeast');
