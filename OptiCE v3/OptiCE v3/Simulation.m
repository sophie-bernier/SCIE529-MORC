% LICENSE
%Copyright (c) <2016> <Pietro Elia Campana, Yang Zhang, and Jinyue Yan>
%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in OptiCE without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom OptiCE is furnished to do so, subject to the following conditions:
%The above copyright notice and this permission notice shall be included in all copies or substantial portions of OptiCE.
%OptiCE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH OptiCE OR THE USE OR OTHER DEALINGS IN OptiCE

clear all;

%% INPUT DATA
if ~exist ('inputValues', 'var')
    inputValues = Read_input_values(1,1);
end
% clearvars -except inputValues;


%% Variables
%[55.3844655751186,7.56529343093971,758402.762437638,30,1452413.05156363,207893.057853184]
%[48.6737157219825,3.49987977407236,734804.749782423,30,2124423.81345882,882421.907931520]
%[61.6758687845085,6.29142411425811,189690.727976873,30,1932434.71541051,834585.068943943]
%[46.5877687790804,3.37509749389162,85.9394154180964,30,1193.80647224284,717.141895210176]
%[55.7235213271067,4.19760263264679,4450743.17341893,10,4836159.01389963,28006147.2475420]
Tilt_angle=55.7;            %Degree
Azimuth_angle=4;          %Degree
Power_rated_pv=4.45E6;     %W
Tower_height=10;          %m
Power_rated_wind=4.8E6;   %W
Battery_capacity=2.8E7;   %Wh

%%
%MAIN CODE SOLAR RADIATION 
[G_T_R,Hour_day,Solar_altitude,Solar_azimuth,Angle_incidence] = RadiationCalculation(inputValues,Tilt_angle,Azimuth_angle);

figure;
hold on;
day = 1;
plot(Hour_day((1:24)+(24*(day-1))),Solar_altitude((1:24)+(24*(day-1))));
plot(Hour_day((1:24)+(24*(day-1))),Solar_azimuth((1:24)+(24*(day-1))));
plot(Hour_day((1:24)+(24*(day-1))),Angle_incidence((1:24)+(24*(day-1))));
grid on;
title("Sun path diagram");
legend("Solar altitude", "Solar azimuth", "Angle of incidence");
xlabel("Local hour");
ylabel("Angle (degrees)");

%MAIN CODE PV
[Power_pv,LCC_pv]=Power_lcc_pv(inputValues,Power_rated_pv,G_T_R);

%MAIN CODE WIND
[Power_wind,LCC_wind]=Power_lcc_wind(inputValues,Power_rated_wind,Tower_height);

%POWER TOTAL RENEWABLES
Power_tot=Power_pv+Power_wind*5;

%OPERATIONAL STRATEGY & BATTERY
[Power_grid,Battery_charged,LCC_battery,Powerbatt]=Operational_strategy(inputValues,Power_tot,Battery_capacity);

%RELIABILITY FUNCTION RENEWABLES
Reliability=zeros(1,8760);
Reliability (find(Power_grid>=0))=1;
Reliability_tot=sum(Reliability);

%DIESEL GENERATOR
[Diesel_rated_power,Diesel_Consumption,LCC_diesel_generator]=Diesel_generator(inputValues,Power_grid);
Diesel_Production=zeros(size(Power_grid));
ind=find(Power_grid<0);
Diesel_Production(ind)=-Power_grid(ind);
%LIFE CYCLE COST
Total_LCC=LCC_pv+LCC_wind+LCC_battery+LCC_diesel_generator;
