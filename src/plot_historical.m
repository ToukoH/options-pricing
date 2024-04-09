clear;
clearvars;
close all;

addpath('./data')

path = "./data/DCOILBRENTEU.csv";
data = readtable(path);

data.DATE = datetime(data.DATE);

figure;
plot(data.DATE, data.DCOILBRENTEU, 'LineWidth', 1.0, 'Color','#8B0000'); % Plot with a thicker line
xlabel('Date');
ylabel('Price (USD)');
grid on;
grid minor;
set(gca, 'FontSize', 12);
set(gcf, 'Color', 'w');

ax = gca;
ax.XGrid = 'on';
ax.YGrid = 'on';


xtickangle(45)

xlim([min(data.DATE) max(data.DATE)])

data.DCOILBRENTEU = fillmissing(data.DCOILBRENTEU, 'linear');


set(gcf, 'Units', 'Inches', 'Position', [0, 0, 10, 6]);