function z = costFun(x)
  windCapacity = x[1];
  dieselCapacity = x[2];
  [powerGenWind, hrsWind] = simulateWind(windCapacity, dieselCapacity);
  z[1] = lcoe(wind);
  z[2] = lca(wind);
  z = checkConstraints();
end

function y = powerCurve(x)
    for i in x
        if x > uCi
            if x < uMax1
                y[i] = s.*x[i];
            elseif x < uMax2
                y[i] = s.*uMax1;
            else
                y[i] = 0;
            end
        else
            y[i] = 0;
        end
    end
end

function y = weibull(k, lambda, x)
  return (k./lambda).*((x./lambda).^(k-1)).*exp((-x./lambda)^k)
end

function y = weibull(k, mean, x)
  return weibull(k, mean./gamma(1+1./k), x);
end

maxWindSpeed = 10;
windK = 2;

function simulate(x)
  windSpeeds = 0:0.1:maxWindSpeed;
  windTimes = weibull(windK, meanWindSpeed, windSpeeds).*(365.25*24);
  windPowers = powerCurve(windSpeeds);
  windEnergies = windTimes.*windPowers; % Wh
  windEnergy = sum(windEnergies);
  dieselEnergy = energyDemand - windEnergy;
end