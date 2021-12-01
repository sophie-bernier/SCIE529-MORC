% LICENSE
%Copyright (c) <2016> <Pietro Elia Campana, Yang Zhang, and Jinyue Yan>
%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in OptiCE without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom OptiCE is furnished to do so, subject to the following conditions:
%The above copyright notice and this permission notice shall be included in all copies or substantial portions of OptiCE.
%OptiCE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH OptiCE OR THE USE OR OTHER DEALINGS IN OptiCE

function [f, ...
          RenewablePower, ...
          Diesel_rated_power, ...
          DieselLitres, ...
          DieselPower, ...
          WindPower, ...
          PVPower, ...
          BatteryPower, ...
          Diesel_CO2_Fuel, ...
          Diesel_CO2_Manufacturing, ...
          Wind_CO2, ...
          PV_CO2, ...
          Battery_CO2] ...
         = Simulation_for_optimization(x,inputValues,calcCO2)
%%DECISIONAL VARIABLES
Tilt_angle=x(1);            %Degree
Azimuth_angle=x(2);         %Degree
Power_rated_pv=x(3);        %W
Tower_height=x(4);          %m
Power_rated_wind=x(5);      %W
Battery_capacity=x(6);      %Wh

%%SIMULATIONS

%MAIN CODE SOLAR RADIATION 
G_T_R= RadiationCalculation(inputValues,Tilt_angle,Azimuth_angle);

%MAIN CODE PV
[Power_pv,LCC_pv]=Power_lcc_pv(inputValues,Power_rated_pv,G_T_R);
PVPower = sum(Power_pv);

%MAIN CODE WIND
[Power_wind,LCC_wind]=Power_lcc_wind(inputValues,Power_rated_wind,Tower_height);
WindPower = sum(Power_wind);

%POWER TOTAL RENEWABLES
Power_tot=Power_pv+Power_wind;

%OPERATIONAL STRATEGY & BATTERY
[Power_grid,~,LCC_battery,Power_battery]=Operational_strategy(inputValues,Power_tot,Battery_capacity);
BatteryPower = sum(Power_battery);

%RELIABILITY FUNCTION RENEWABLES
Reliability=zeros(1,8760);
Reliability (find (Power_grid>=0))=1;
Reliability_tot=sum(Reliability);
RenewablePower = sum(Power_tot);

%DIESEL GENERATOR
[Diesel_rated_power,Diesel_Consumption,LCC_diesel_generator,Annual_Diesel_CO2]=Diesel_generator(inputValues,Power_grid);
DieselLitres = sum(Diesel_Consumption);
Diesel_Production=zeros(size(Power_grid));
ind=find(Power_grid<0);
Diesel_Production(ind)=-Power_grid(ind);
DieselPower = sum(Diesel_Production);
%LIFE CYCLE COST and LCOE
Total_LCC=LCC_pv+LCC_wind+LCC_battery+LCC_diesel_generator;

%LCCO2
Diesel_CO2_Fuel = 1000*Annual_Diesel_CO2*inputValues.Project_lifetime;
Diesel_CO2_Manufacturing = Diesel_rated_power*inputValues.Specific_CO2_diesel;
Wind_CO2 = Power_rated_wind*inputValues.Specific_CO2_wind;
PV_CO2 = Power_rated_pv*inputValues.Specific_CO2_pv;
Battery_CO2 = Battery_capacity*inputValues.Specific_CO2_battery;
LCCO2 = Diesel_CO2_Fuel + Diesel_CO2_Manufacturing + Wind_CO2 + PV_CO2 + Battery_CO2;

%%
%DEFINE OBJECTIVE FUNCTIONS
f(1)=Total_LCC;
f(2)= -Reliability_tot;
if (calcCO2 == false)
    f(3)=0;
else
    f(3)=LCCO2;
end
