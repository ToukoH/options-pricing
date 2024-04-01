clear;
clearvars;
addpath('./data')

path = "/DCOILBRENTEU.csv";
data = readtable(path);

n = 5000;
length = 600;
initial_price = 70;
paths = simulate_paths(path, initial_price, length, n);

figure;
plot(paths)
hold on;
title("Simulated price paths for crude oil")
xlabel("Days")
ylabel("Price in $")
hold off;

strike = 40;
side = 1;

payouts_asian = valuate_asian(paths, strike, side);
payouts_european = valuate_european(paths, strike, side);
figure;
histogram(payouts_asian)
hold on;
histogram(payouts_european)
histogram(paths(end, :))
legend("Asian Options Payouts", "European Options Payouts", "Underlying Price at End")
hold off;

mean_payout_european = mean(payouts_european);
mean_payout_asian = mean(payouts_asian);

fprintf('Mean payout of European options: %f\n', mean_payout_european);
fprintf('Mean payout of European options: %f\n', mean_payout_asian);

function payouts = valuate_asian(price_paths, strike, call_put) % 1 for call, 2 for put
    means = mean(price_paths);

    if call_put == 1
        payouts = max(means- strike, 0);
    else
        payouts = max(strike - means, 0);
    end
end

function payouts = valuate_european(price_paths, strike, call_put) % 1 for call, 2 for put
    spot = price_paths(end, :);

    if call_put == 1
        payouts = max(spot- strike, 0);
    else
        payouts = max(strike - spot, 0);
    end
end