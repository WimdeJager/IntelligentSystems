function new_p = new_prototype(step_size, x1, y1, x2, y2)
x_diff = abs(x2-x1);
y_diff = abs(y2-y1);

if x1 < x2
	x3 = x1 + (x_diff*step_size);
else
	x3 = x1 - (x_diff*step_size);
end

if y1 < y2
	y3 = y1 + (y_diff*step_size);
else
	y3 = y1 - (y_diff*step_size);
end

new_p = [x3,y3];