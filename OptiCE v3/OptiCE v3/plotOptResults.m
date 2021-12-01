%LOWER AND UPPER BOUNDS OF THE DECISIONAL VARIABLES 
% [Tilt angle;Azimuth angle;PV rated power;Tower height;Wind turbine rated power;Battery capacity]
% Algorithm basically exploits everything to the max
% need to automatically generate covariance matrix
% no constraints here except limits on the decision variables

lb = [46;-5;1;10;1;1];
cap = 1E6;
battcap=10*cap;

ub(:,1) = [69;5;cap;10;cap;battcap];
ub(:,2) = [69;5;cap;10;1;1];
ub(:,3) = [69;5;cap;10;1;battcap];
ub(:,4) = [69;5;1;10;cap;1];
ub(:,5) = [69;5;1;10;cap;battcap];
ub(:,6) = [69;5;cap;10;cap;1];

optimize = false;
populationSize = 50;
numberOfGenerations = 50;

if (~exist('inputValues','var'))
    inputValues = Read_input_values(1,1);
    optimize = true;
end

if (~exist('finalScores','var') ...
        || ~exist('population','var') ...
        || ~exist('scores','var') ...
        || ~exist('RenewablePower','var') ...
        || ~exist('DieselPower','var'))
    finalScores = zeros(populationSize,3,6);
    population = zeros(populationSize,6,6);
    scores = zeros(populationSize,3,6);
    RenewablePower = zeros(populationSize,6);
    DieselRatedPower = zeros(populationSize,6);
    WindPower = zeros(populationSize,6);
    PVPower = zeros(populationSize,6);
    BatteryPower = zeros(populationSize,6);
    DieselPower = zeros(populationSize,6);
    Diesel_CO2_Fuel = zeros(populationSize,6);
    Diesel_CO2_Manufacturing = zeros(populationSize,6);
    Wind_CO2 = zeros(populationSize,6);
    PV_CO2 = zeros(populationSize,6);
    Battery_CO2 = zeros(populationSize,6);
    DieselLitres = zeros(populationSize,6);
    lcoe = zeros(populationSize,6);
    optimize = true;
end

ref = [45,0,0,10,0,1];
[refScore,refRenewablePower,~,refDieselLitres,refDieselPower] = Simulation_for_optimization(ref,inputValues,true);
refLcoe = 1000.*refScore(:,1)./(inputValues.Project_lifetime.*sum(inputValues.Electric_load));

markerShape = ['o' 's' '^' 'v' '<' '>'];

lccLabel = "Lifecycle cost ($)";
reliabilityLabel = "PV/wind/battery reliability (hrs/yr)";
lcco2Label = "Lifecycle CO2 emissions (kg)";
dieselPowerLabel = "Annual power from the diesel generator (Wh)";
dieselLitresLabel = "Annual fuel consumption of the diesel generator (L)";
lcoeLabel = "Lifetime levelized cost of energy ($/kWh)";

figure;
optResults = axes;
title("Optimization results");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
grid on;
hold on;
xlabel(lccLabel);
ylabel(reliabilityLabel);
zlabel(lcco2Label);
view(45+180,30);
optResultsPts = zeros(populationSize,7);
optResultsPts(1,7) = scatter3(optResults, ...
         refScore(1), ... 
         -1.*refScore(2), ...
         refScore(3), ...
         'd', ...
         'MarkerEdgeColor','k', ...
         'MarkerFaceColor','k');

figure;
lccWrtLCCO2 = axes;
title("Optimization results: Lifecycle cost as a function of lifecycle CO2");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
xlabel(lcco2Label);
ylabel(lccLabel);
hold on;
grid on;
lccWrtLCCO2Pts = zeros(populationSize,7);
lccWrtLCCO2Pts(1,7) = scatter(lccWrtLCCO2, ...
        refScore(3), ... 
        refScore(1), ...
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

figure;
reliabilityWrtLCCO2 = axes;
title("Optimization results: Reliability as a function of lifecycle CO2");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
ylabel(reliabilityLabel);
xlabel(lcco2Label);
hold on;
grid on;
reliabilityWrtLCCO2Pts = zeros(populationSize,7);
reliabilityWrtLCCO2Pts(1,7) = scatter(reliabilityWrtLCCO2, ...
        refScore(3), ... 
        -1.*refScore(2), ...
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

figure;
lccWrtReliability = axes;
title("Optimization results: Lifecycle cost as a function of reliability");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
xlabel(reliabilityLabel);
ylabel(lccLabel)
hold on;
grid on;
lccWrtReliabilityPts = zeros(populationSize,7);
lccWrtReliabilityPts(1,7) = scatter(lccWrtReliability, ...
        -1.*refScore(2), ...
        refScore(1), ... 
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

figure;
dieselPowerWrtLCC = axes;
title("Optimization results: Annual diesel energy as a function of lifecycle cost");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
xlabel(lccLabel);
ylabel(dieselPowerLabel)
hold on;
grid on;
dieselPowerWrtLCCPts = zeros(populationSize,7);
dieselPowerWrtLCCPts(1,7) = scatter(dieselPowerWrtLCC, ...
        refScore(1), ...
        refDieselPower, ... 
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

figure;
dieselPowerWrtLCCO2 = axes;
title("Optimization results: Annual diesel energy as a function of lifecycle CO2");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
xlabel(lcco2Label);
ylabel(dieselPowerLabel)
hold on;
grid on;
dieselPowerWrtLCCO2Pts = zeros(populationSize,7);
dieselPowerWrtLCCO2Pts(1,7) = scatter(dieselPowerWrtLCCO2, ...
        refScore(3), ...
        refDieselPower, ... 
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

figure;
dieselFuelWrtLcoe = axes;
title("Optimization results: Annual fuel consumption as a function of lifetime LCOE");
subtitle("Marker fill; R:PV, G:Wind, B:Battery");
xlabel(lcoeLabel);
ylabel(dieselLitresLabel);
hold on;
grid on;
dieselFuelWrtLcoePts = zeros(populationSize,7);
dieselFuelWrtLcoePts(1,7) = scatter(dieselFuelWrtLcoe, ...
        refLcoe, ...
        refDieselLitres, ... 
        'd', ...
        'MarkerEdgeColor','k', ...
        'MarkerFaceColor','k');

for i = 1:6
    if optimize
        [population(:,:,i), ...
         scores(:,:,i)] ...
        = Optimization (lb, ub(:,i), inputValues, ...
                        populationSize, numberOfGenerations);
    end
    if true
        [finalScores(:,:,i), ...
         RenewablePower(:,i), ...
         DieselRatedPower(:,i), ...
         DieselLitres(:,i), ...
         DieselPower(:,i), ...
         WindPower(:,i), ...
         PVPower(:,i), ...
         BatteryPower(:,i),...
         Diesel_CO2_Fuel(:,i), ...
         Diesel_CO2_Manufacturing(:,i), ...
         Wind_CO2(:,i), ...
         PV_CO2(:,i), ...
         Battery_CO2(:,i)] ...
        = calcFinalScores(population(:,:,i), inputValues);
    end
    %%
    maxPV(i) = max(max(population(:,3,i)),10);
    maxWind(i) = max(max(population(:,5,i)),10);
    maxBattery(i) = max(max(population(:,6,i)),10);
    maxOfMax(i) = max(max([maxPV(i), maxWind(i), maxBattery(i)]),10);
    %%
    minLCC(i) = min(finalScores(:,1,i));
    maxReliability(i) = min(finalScores(:,2,i));
    minLCCO2(i) = min(finalScores(:,3,i));
    %%
    minLCCIdx(i) = find(finalScores(:,1,i) == minLCC(i),1);
    minLCCO2Idx(i) = find(finalScores(:,3,i) == minLCCO2(i),1);
    maxReliabilityIdx(i) = find(finalScores(:,2,i) == maxReliability(i),1);
    %%
    
    lcoe(:,i) = 1000.*finalScores(:,1,i)./(inputValues.Project_lifetime.*sum(inputValues.Electric_load));
    
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        optResultsPts(j,i) = scatter3(optResults, ...
                 finalScores(j,1,i), ... 
                 -1.*finalScores(j,2,i), ...
                 finalScores(j,3,i), ...
                 markerShape(i), ...
                 'MarkerEdgeColor',markerEdgeColor, ...
                 'LineWidth',lineWidth,...
                 'MarkerFaceColor', [population(j,3,i)/cap ...
                                     population(j,5,i)/cap ...
                                     population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        lccWrtLCCO2Pts(j,i) = scatter(lccWrtLCCO2, ...
                finalScores(j,3,i), finalScores(j,1,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        reliabilityWrtLCCO2Pts(j,i) = scatter(reliabilityWrtLCCO2, ...
                finalScores(j,3,i), -1.*finalScores(j,2,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        lccWrtReliabilityPts(j,i) = scatter(lccWrtReliability, ...
                -1.*finalScores(j,2,i), finalScores(j,1,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        dieselPowerWrtLCCPts(j,i) = scatter(dieselPowerWrtLCC, ...
                finalScores(j,1,i), DieselPower(j,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        dieselPowerWrtLCCO2Pts(j,i) = scatter(dieselPowerWrtLCCO2, ...
                finalScores(j,3,i), DieselPower(j,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    for j = 1:(size(population))(1);
        if find(j == minLCCIdx(i))
            markerEdgeColor = 'r';
            lineWidth = 2;
        elseif find(j == minLCCO2Idx(i))
            markerEdgeColor = 'g';
            lineWidth = 2;
        elseif find(j == maxReliabilityIdx(i))
            markerEdgeColor = 'b';
            lineWidth = 2;
        else
            markerEdgeColor = 'k';
            lineWidth = 0.5;
        end
        dieselFuelWrtLcoePts(j,i) = scatter(dieselFuelWrtLcoe, ...
                lcoe(j,i), DieselLitres(j,i), ...
                markerShape(i), ...
                'MarkerEdgeColor',markerEdgeColor, ...
                'LineWidth',lineWidth,...
                'MarkerFaceColor', [population(j,3,i)/cap ...
                                    population(j,5,i)/cap ...
                                    population(j,6,i)/battcap]);
    end
    %%
    
    % one column per row
    idx(i) = min(minLCCO2Idx(i)); %min(minLCCIdx);
    emissionsBarData(i,1) = Diesel_CO2_Fuel(idx(i),i);
    emissionsBarData(i,2) = Diesel_CO2_Manufacturing(idx(i),i);
    emissionsBarData(i,3) = Wind_CO2(idx(i),i);
    emissionsBarData(i,4) = PV_CO2(idx(i),i);
    emissionsBarData(i,5) = Battery_CO2(idx(i),i);
    powerBarData(i,1) = DieselPower(idx(i),i);
    powerBarData(i,2) = WindPower(idx(i),i);
    powerBarData(i,3) = PVPower(idx(i),i);
    powerBarData(i,4) = -1.*BatteryPower(idx(i),i);
    capacityBarData(i,1) = DieselRatedPower(idx(i),i);
    capacityBarData(i,2) = population(idx(i),5,i);
    capacityBarData(i,3) = population(idx(i),3,i);
    capacityBarData(i,4) = population(idx(i),6,i);
    costBarData(i) = finalScores(idx(i),1,i);
end



figure;
hold on;
subplot(6,1,1);
bar(gca,emissionsBarData(:,1), 'stacked');
title(gca,"Lifecycle CO2 emissions, energy production, and cost for different grid composition constraints");
subtitle(gca,"Lifecycle diesel fuel emissions (kg)");
subplot(6,1,2);
bar(gca,emissionsBarData(:,2:end), 'stacked');
legend(gca,"Diesel", "Wind", "PV", "Battery",'Location','best');
subtitle(gca,"Other lifecycle emissions (kg)");
subplot(6,1,3);
bar(gca,powerBarData, 'stacked');
legend(gca,"Diesel", "Wind", "PV", "Battery",'Location','best');
subtitle(gca,"Annual energy production (Wh)");
subplot(6,1,4);
bar(gca,capacityBarData(:,1:3), 'stacked');
legend(gca,"Diesel", "Wind", "PV",'Location','best');
subtitle(gca,"Installed generation capacity (W)");
subplot(6,1,5);
bar(gca,capacityBarData(:,4), 'stacked');
subtitle(gca,"Installed battery storage capacity (Wh)");
subplot(6,1,6);
bar(gca,costBarData, 'stacked');
subtitle(gca,lccLabel);
set(gca,'xticklabel', {'PV/W/B/D\n', ...
                       'PV/D', ...
                       'PV/B/D', ...
                       'W/D', ...
                       'W/B/D', ...
                       'PV/W/D'});
                   
generateLegend(optResultsPts, idx);
generateLegend(lccWrtLCCO2Pts, idx);
generateLegend(reliabilityWrtLCCO2Pts, idx);
generateLegend(lccWrtReliabilityPts, idx);
generateLegend(dieselPowerWrtLCCPts, idx);
generateLegend(dieselPowerWrtLCCO2Pts, idx);
generateLegend(dieselFuelWrtLcoePts, idx);

%ub(:,1) = [69;5;cap;10;cap;battcap];
%ub(:,2) = [69;5;cap;10;1;1];
%ub(:,3) = [69;5;cap;10;1;battcap];
%ub(:,4) = [69;5;1;10;cap;1];
%ub(:,5) = [69;5;1;10;cap;battcap];
%ub(:,6) = [69;5;cap;10;cap;1];

function generateLegend(points, idx)
legend([points(idx(1),1), ...
        points(idx(2),2), ...
        points(idx(3),3), ...
        points(idx(4),4), ...
        points(idx(5),5), ...
        points(idx(6),6), ...
        points(1,7)], ...
        {'PV/Wind/Battery + Diesel', ...
         'PV + Diesel', ...
         'PV/Battery + Diesel', ...
         'Wind + Diesel', ...
         'Wind/Battery + Diesel', ...
         'PV/Wind + Diesel','Diesel'}, ...
         'Location', 'eastoutside');
end