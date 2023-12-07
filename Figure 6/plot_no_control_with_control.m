clear
clc

Vec=["0.00","0.05","0.10","0.15","0.20",...
     "0.25","0.30","0.35","0.40","0.45","0.50"];

Data_no_control=csvread('R_end_smaller_range.csv');
Data_with_control=csvread('R_end_smaller_range_with_control.csv');

figure;
subplot(1,2,1);
plot(str2double(Vec), Data_no_control(end,:), 'o', 'Color', 'm', 'DisplayName', 'No Control');
hold on;
plot(str2double(Vec), Data_with_control(end,:), 'o', 'Color', 'b', 'DisplayName', 'With Control');
xlabel('Information spreading rate (\lambda)', 'FontSize', 16);
ylabel('Recovered (end)', 'FontSize', 16);
legend('Location', 'best');

subplot(1,2,2);
percentage_reduction = (Data_no_control(end,:) - Data_with_control(end,:)) ./ Data_no_control(end,:) * 100;
plot(str2double(Vec), percentage_reduction, 'o', 'Color', 'r', 'DisplayName', 'Percentage Reduction');
xlabel('Information spreading rate (\lambda)', 'FontSize', 16);
ylabel('Percentage Reduction (%)', 'FontSize', 16);

saveas(gcf, 'no_control_versus_with_control.pdf');
