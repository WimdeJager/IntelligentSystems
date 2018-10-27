function test_error = test_prototypes(test_set, prototypes)
% The last column of the test tells us which class the row belongs to
[test_set_size, test_set_dimension] = size(test_set);
[prototype_count, prototype_dimension] = size(prototypes);

test_error = 0;
for j = 1:test_set_size
    example_x = test_set(j,1);
    example_y = test_set(j,2);
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
    if ((prototypes(winner_idx,4) == 1) && (test_set(j,3) == 2)) ...
            || ((prototypes(winner_idx,4) == 2) && (test_set(j,3) == 1)) % different class
        test_error = test_error + 1;
    end
end
end
