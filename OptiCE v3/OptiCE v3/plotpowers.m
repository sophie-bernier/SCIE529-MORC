function plotpowers(x_min, x_max, pow_1, pow_2)
figure;
hold on;
fplot(@(x) 1.*(x.^pow_1) - 1.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 2.*(x.^pow_1) - 1.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 1.*(x.^pow_1) - 2.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 0.5.*(x.^pow_1) - 1.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 1.*(x.^pow_1) - 0.5.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 4.*(x.^pow_1) - 1.*(x.^pow_2), [x_min,x_max])
fplot(@(x) 1.*(x.^pow_1) - 4.*(x.^pow_2), [x_min,x_max])
legend('location','northeastoutside');
end