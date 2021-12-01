function [finalScores, RenewablePower, Diesel_rated_power, DieselLitres, DieselPower, WindPower, PVPower, BatteryPower, Diesel_CO2_Fuel, Diesel_CO2_Manufacturing, Wind_CO2, PV_CO2, Battery_CO2] = calcFinalScores (population, inputValues)

%%CALC SCORES INCORPORATING CO2
finalScores = zeros(length(population),3);
RenewablePower = zeros(length(population),1);
DieselPower = zeros(length(population),1);
Diesel_CO2_Fuel = zeros(length(population),1);
Diesel_CO2_Manufacturing = zeros(length(population),1);
Wind_CO2 = zeros(length(population),1);
PV_CO2 = zeros(length(population),1);
Battery_CO2 = zeros(length(population),1);
WindPower = zeros(length(population),1);
PVPower = zeros(length(population),1);
BatteryPower = zeros(length(population),1);
Diesel_rated_power = zeros(length(population),1);
DieselLitres = zeros(length(population),1);
for i = 1:length(population)
    [finalScores(i,:), ...
     RenewablePower(i), ...
     Diesel_rated_power(i), ...
     DieselLitres(i), ...
     DieselPower(i), ...
     WindPower(i), ...
     PVPower(i), ...
     BatteryPower(i), ...
     Diesel_CO2_Fuel(i), ...
     Diesel_CO2_Manufacturing(i), ...
     Wind_CO2(i), ...
     PV_CO2(i), ...
     Battery_CO2(i)] ...
    = Simulation_for_optimization(population(i,:),inputValues,true);
end