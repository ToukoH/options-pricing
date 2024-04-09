

function sim_matrix = simulate_paths(path, starting_price, length, n)
    data = readtable(path);
    
    data.Properties.VariableNames = ["date","crude"];
    
    returns = pct_change(data.crude); % calculate returns from spot prices
    returns = returns(~isnan(returns)); % delete NaN values
    dist = fitdist(returns, 'Normal');
    random_walk = random(dist, [length - 1, n]);
    sim_matrix = zeros(length, n);
    sim_matrix(1, :) = starting_price;
    sim_matrix(2:end, :) = 1 + random_walk;
    sim_matrix = cumprod(sim_matrix);
end

function p = pct_change(x)
    p = diff(x)./x(1:end-1); 
end