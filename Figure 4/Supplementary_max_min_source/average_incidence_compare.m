clear
clc

% gamma = 4, kmin = 3
Data_min = csvread('recovered_gamma_4.0_min_source.csv', 1);
Data_max = csvread('recovered_gamma_4.0_max_source.csv', 1);

% gamma = 4.75, kmin = 3
%Data_min = csvread('recovered_gamma_4.75_min_source.csv', 1);
%Data_max = csvread('recovered_gamma_4.75_max_source.csv', 1);

% Preprocess min data
for kk = 1:100
    idx = max(find(Data_min(2*(kk-1)+1,:) > 0));
    Data_min(2*(kk-1)+1,idx:end) = Data_min(2*(kk-1)+1,idx);
    Data_min(2*kk,idx:end) = Data_min(2*kk,idx);
end

% Preprocess max data
for kk = 1:100
    idx = max(find(Data_max(2*(kk-1)+1,:) > 0));
    Data_max(2*(kk-1)+1,idx:end) = Data_max(2*(kk-1)+1,idx);
    Data_max(2*kk,idx:end) = Data_max(2*kk,idx);
end

YY_min = zeros(100, 150);
YY_max = zeros(100, 150);

% Incidence for min data
for kk = 1:100
    Inc = zeros(1, 150);
    
    for ii = 1:150
        idx1 = find(Data_min(2*(kk-1)+1,:) < ii);
        idx = find(Data_min(2*(kk-1)+1,:) <= ii+1);
        
        if (~isempty(idx1) && ~isempty(idx))
            Inc(ii) = Data_min(2*kk,max(idx)) - Data_min(2*kk,max(idx1));
        else
            Inc(ii) = 0;
        end
    end
    
    YY_min(kk, :) = Inc;
end

% Incidence for max data
for kk = 1:100
    Inc = zeros(1, 150);
    
    for ii = 1:150
        idx1 = find(Data_max(2*(kk-1)+1,:) < ii);
        idx = find(Data_max(2*(kk-1)+1,:) <= ii+1);
        
        if (~isempty(idx1) && ~isempty(idx))
            Inc(ii) = Data_max(2*kk,max(idx)) - Data_max(2*kk,max(idx1));
        else
            Inc(ii) = 0;
        end
    end
    
    YY_max(kk, :) = Inc;
end

% Calculate mean for min and max data
ZZ_min = mean(YY_min);
ZZ_max = mean(YY_max);

% Total recovered percentage
total_recovered_percentage_min = sum(ZZ_min)/ 500 * 100;
total_recovered_percentage_max = sum(ZZ_max)/ 500 * 100;

% Adjust figure size
figure('Units', 'inches', 'Position', [0, 0, 8, 6]);

% Plot
plot(ZZ_min, '-', 'LineWidth', 2.0, 'DisplayName', sprintf('Min Source\nTotal Recovered: %.2f%%', total_recovered_percentage_min))
hold on
plot(ZZ_max, '-', 'LineWidth', 2.0, 'DisplayName', sprintf('Max Source\nTotal Recovered: %.2f%%', total_recovered_percentage_max))
hold off
xlabel('Time')
ylabel('Average Incidence')
legend('Location', 'best')

% Save the data
csvwrite('average_incidence_gamma_4.0_min_source.csv', ZZ_min);
csvwrite('average_incidence_gamma_4.0_max_source.csv', ZZ_max);
%csvwrite('average_incidence_gamma_4.75_min_source.csv', ZZ_min);
%csvwrite('average_incidence_gamma_4.75_max_source.csv', ZZ_max);

% Save plot
saveas(gcf, 'plot_average_incidence_gamma_4.0.pdf');
%saveas(gcf, 'plot_average_incidence_gamma_4.75.pdf');
