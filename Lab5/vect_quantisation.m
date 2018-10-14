load('w6_1x.mat');
load('w6_1y.mat');
load('w6_1z.mat');

% 3 datasets of 2-dimensional points
x = w6_1x;
y = w6_1y;
z = w6_1z;

% Getting prototypes
num_prototypes = 2 % Number of prototypes
prototypes = zeros(num_prototypes,3); % 3rd columns records idx in dataset
for i = 1:num_prototypes
	r = randi(1000);
	if i ~= 1
		while ismember(r,prototypes(:,3)) ~= 0
			r = randi(2000)
		end
	end
	prototypes(i,1) = x(r,1);
	prototypes(i,2) = x(r,2);
	prototypes(i,3) = r;
end
