clear;
clearvars;
close all;
rng(50) % for reproductibility

addpath('./data')

path = "/DCOILBRENTEU.csv";
data = readtable(path);

initial_prices = [70];
n = 5000;
length_sim = 50;
strikes = [60, 90];
sides = [1, 2];

results = zeros(length(initial_prices) + length(strikes) + length(sides), 7);
i = 1;

figure_n = 1;

for initial_price = initial_prices
    fprintf("Initial price is  %d\n", initial_price);
    paths = simulate_paths(path, initial_price, length_sim, n);
    
    for side = sides
        if side == 1
            side_name = "call";
            fprintf("Side is call\n");
        else
            side_name = "put";
            fprintf("Side is put\n");
        end

        for strike = strikes
            
            if figure_n == 1
                figure(figure_n);
                plot(paths)
                hold on;
                title("Simulated price paths for crude oil for t = " + length_sim)
                xlabel("Days")
                ylabel("Price in $")
                hold off;
                figure_n = figure_n + 1;
            end

            fprintf("Strike is  %d\n", strike)
    
            payouts_asian = valuate_asian(paths, strike, side);
            payouts_asian_floating = valuate_asian_floating_strike(paths, side);
            payouts_european = valuate_european(paths, strike, side);

            asset_prices = paths(end, :);

            paths_chosen = paths(:, randi(n, 1, 5));
            asian_option_prices = valuate_asian(paths_chosen, strike, side) + 0.1;
            european_option_prices = valuate_european(paths_chosen, strike, side) + 0.1;
            asian_option_prices_float = valuate_asian_floating_strike(paths_chosen, side) + 0.1;


            figure(figure_n)
            subplot(1, 2, 1)
            plot(paths_chosen, LineWidth=1.5);
            hold on;
            yline(strike, '--', LineWidth=2)
            title("Chosen simulated price paths")
            ylabel("Price")
            xlabel("Time")
            legend("Line 1", "Line 2", "Line 3", "Line 4", "Line 5", "Strike")
            subplot(1, 2, 2)
            option_prices = [european_option_prices; asian_option_prices; asian_option_prices_float].';
            barh(option_prices, 1, 'grouped');
            xlabel("Option Price")
            ylabel("Line")
            title("Option Payouts")
            legend("European Options", "Asian Options with Fixed Strike", "Asian Options with Floating Strike")
            hold off;
            sgtitle("Side: " + side_name + " strike: " + strike + " init. price: " + initial_price + " t = " + length_sim)
            figure_n = figure_n + 1;
            
            figure(figure_n)
            subplot(2, 1, 1);
            histogram(payouts_asian,'FaceAlpha',0.3)
            hold on;
            histogram(payouts_european,'FaceAlpha',0.3)
            histogram(payouts_asian_floating,'FaceAlpha',0.3)
            title("Option Payouts")
            legend("Fixed Strike Asian Options Payouts", "European Options Payouts", "Floating Strike Asian Options Payouts")
            hold off;
            
            
            subplot(2, 1, 2);
            histogram(asset_prices)
            hold on;
            title("Expected Asset Prices at end of t = " + length_sim)
            hold off;
            sgtitle("Side: " + side_name + " strike: " + strike + " init. price: " + initial_price + " t = " + length_sim)
            
            mean_asset_prices = mean(asset_prices);
            std_asset_prices = std(asset_prices);
            fprintf('Expected asset price at end: %f\n', mean_asset_prices);
            fprintf('Expected asset price stdev at end: %f\n', std_asset_prices);
            
            mean_payout_european = mean(payouts_european);
            mean_payout_asian = mean(payouts_asian);
            mean_payout_asian_floating = mean(payouts_asian_floating);
            
            fprintf('Mean payout of European options: %f\n', mean_payout_european);
            fprintf('Mean payout of Asian options: %f\n', mean_payout_asian);
            fprintf('Mean payout of floating strike Asian options: %f\n', mean_payout_asian_floating);

            results(i, 1) = side;
            results(i, 2) = strike;
            results(i, 3) = initial_price;
            results(i, 4) = mean_payout_asian;
            results(i, 5) = mean_payout_asian_floating;
            results(i, 6) = mean_payout_european;
            results(i, 7) = mean_asset_prices;
            
            figure_n = figure_n + 1;
            i = i + 1;

            %break
        end
        %break
    end
    %break
end

results = array2table(results);
results.Properties.VariableNames(1:7) = {'side','strike','initial_price','mean_payout_asian_fixed', 'mean_payout_asian_floating', 'mean_payout_european', 'mean_asset_price'};

function payouts = valuate_asian(price_paths, strike, call_put) % 1 for call, 2 for put
    means = mean(price_paths);

    if call_put == 1
        payouts = max(means- strike, 0);
    else
        payouts = max(strike - means, 0);
    end
end

function payouts = valuate_asian_floating_strike(price_paths, call_put) % 1 for call, 2 for put
    strike = mean(price_paths);
    spot = price_paths(end, :);

    if call_put == 1
        payouts = max(spot - strike, 0);
    else
        payouts = max(strike - spot, 0);
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