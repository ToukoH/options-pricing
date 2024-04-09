clear;
clearvars;
addpath('./data')

path = "/DCOILBRENTEU.csv";
data = readtable(path);

data.Properties.VariableNames = ["date","crude"];

returns = pct_change(data.crude); % calculate returns from spot prices
returns = returns(~isnan(returns)); % delete NaN values

x_values = linspace(-0.2, 0.2, 500);
dist = fitdist(returns, 'Normal');
figure;
histogram(returns, 'Normalization','pdf');
hold on;
plot(x_values, pdf(dist, x_values))
hold off;

function p = pct_change(x)
    p = diff(x)./x(1:end-1); 
end