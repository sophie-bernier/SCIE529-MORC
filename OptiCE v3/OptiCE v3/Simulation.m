% LICENSE
%Copyright (c) <2016> <Pietro Elia Campana, Yang Zhang, and Jinyue Yan>
%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files, to deal in OptiCE without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom OptiCE is furnished to do so, subject to the following conditions:
%The above copyright notice and this permission notice shall be included in all copies or substantial portions of OptiCE.
%OptiCE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH OptiCE OR THE USE OR OTHER DEALINGS IN OptiCE

clear all;

%% INPUT DATA
if ~exist ('inputValues', 'var');
   
%Climatic data
G_H_R=(xlsread('Input','Climatic_data', 'A2:A8761'))';                      %Global horizontal radiation
D_H_R=(xlsread('Input','Climatic_data', 'B2:B8761'))';                      %Diffuse horizontal radiation
Ambient_temperature=(xlsread('Input','Climatic_data', 'C2:C8761'))';        %Ambient temperature
Wind_speed=(xlsread('Input','Climatic_data', 'D2:D8761'))';                 %Wind speed 10 m height

%Solar radiation data
Hour=(xlsread('Input','Solar_radiation','A2:A8761'))';                      %Parameter for calculations
Hour_day=(xlsread('Input','Solar_radiation','B2:B8761'))';                  %Parameter for calculations
c=(xlsread('Input','Solar_radiation','C2:C8761'))';                         %Parameter for calculations
Day_year=(xlsread('Input','Solar_radiation','D2:D8761'))';                  %Parameter for calculations
Latitude=(xlsread('Input','Solar_radiation','G2'));                         %Latitude
Standard_meridian=(xlsread('Input','Solar_radiation','G3'));                %Longitude
Local_meridian=(xlsread('Input','Solar_radiation','G4'));                   %Local meridian
Ground_reflectance=(xlsread('Input','Solar_radiation','G5'));               %Ground reflectance

%PV system data    
eta_pv_stc=(xlsread('Input','PV_system','B2'));                             %Efficiency at standard test conditions 
mu_Voc=(xlsread('Input','PV_system','B3'));                                 %Temperature coefficient of open circuit voltage
V_mp=(xlsread('Input','PV_system','B4'));                                   %Voltage at maximum power point
T_stc=(xlsread('Input','PV_system','B5'));                                  %Temperature at standard test conditions 
NOCT=(xlsread('Input','PV_system','B6'));                                   %Nominal operating cell temperature
Area_pv=(xlsread('Input','PV_system','B7'));                                %PV module area 
Power_module_pv=(xlsread('Input','PV_system','B8'));                        %PV module power peak

%Wind power system data
Vc=(xlsread('Input','Wind_power_system','B2'));                             %Cut-in wind speed
Vr=(xlsread('Input','Wind_power_system','B3'));                             %Rated wind speed
Vo=(xlsread('Input','Wind_power_system','B4'));                             %Cut-out wind speed
eta_m=(xlsread('Input','Wind_power_system','B5'));                          %Mechanical efficiency
eta_e=(xlsread('Input','Wind_power_system','B6'));                          %Electrical efficiency
C_p=(xlsread('Input','Wind_power_system','B7'));                            %Coefficient of performance
rho=(xlsread('Input','Wind_power_system','B8'));                            %Air density

%Inverter data
eta_inverter=(xlsread('Input','Inverter', 'B2'));                           %Inverter Efficiency

%Battery model: Simple energy balance
Control_soc=(xlsread('Input','Battery','B2'));                             %Minimum SOC
eta_battery=(xlsread('Input','Battery','B3'));                             %Efficiency of the battery
sigma=(xlsread('Input','Battery','B4'));                                   %Self-discharge

%Carbon emissions data
Carbon_tax=(xlsread('Input','Carbon_emissions','B2'));                      %Carbon tax
Specific_carbon_emissions=(xlsread('Input','Carbon_emissions','B3'));       %Specific carbon emissions 


%Electric and thermal load data
Electric_load=(xlsread('Input','Load', 'A2:A8761'))';                       %Hourly electric load for the whole year

%System cost data
Specific_cost_pv=(xlsread('Input','System_cost', 'B2'));                    %Specific cost PV system
Specific_cost_wind=(xlsread('Input','System_cost', 'B3'));                  %Specific cost wind system
Specific_cost_battery=(xlsread('Input','System_cost', 'B4'));               %Specific cost battery
Specific_cost_inverter=(xlsread('Input','System_cost', 'B5'));              %Specific cost inverter
Specific_cost_diesel_generator=(xlsread('Input','System_cost', 'B6'));      %Specific cost diesel generator
Specific_cost_diesel=(xlsread('Input','System_cost', 'B7'));                %Specific cost diesel fuel
Specific_cost_grid=(xlsread('Input','System_cost', 'B8'));                  %Specific cost electricty taken from grid
Specific_cost_grid_surplus=(xlsread('Input','System_cost', 'B9'));          %Specific cost electricty fed into the grid
Project_lifetime=(xlsread('Input','System_cost', 'B10'));                   %Project lifetime
pv_lifetime=(xlsread('Input','System_cost', 'B11'));                        %PV system lifetime
wind_lifetime=(xlsread('Input','System_cost', 'B12'));                      %Wind power system lifetime
battery_lifetime=(xlsread('Input','System_cost', 'B13'));                   %Battery lifetime
inverter_lifetime=(xlsread('Input','System_cost', 'B14'));                  %Inverter lifetime
diesel_generator_lifetime=(xlsread('Input','System_cost', 'B15'));          %Diesel generator lifetime
Tax_rate=(xlsread('Input','System_cost', 'B16'));                           %Tax rate
Interest_rate=(xlsread('Input','System_cost', 'B17'));                      %Interest rate
Maintenance_rate_pv=(xlsread('Input','System_cost', 'B18'));                   %Maintenance rate
Maintenance_rate_wind=(xlsread('Input','System_cost', 'B19'));  
Maintenance_rate_battery=(xlsread('Input','System_cost', 'B20'));
Maintenance_rate_diesel_generator=(xlsread('Input','System_cost', 'B21'));

%STORE INPUT DATA FOR OPTIMIZATION
%Climatic data
inputValues.G_H_R=G_H_R;
inputValues.D_H_R=D_H_R;             
inputValues.Ambient_temperature=Ambient_temperature;
inputValues.Wind_speed=Wind_speed;
%Solar radiation data
inputValues.Hour=Hour;
inputValues.Hour_day=Hour_day;
inputValues.c=c;
inputValues.Day_year=Day_year;
inputValues.Latitude=Latitude;
inputValues.Standard_meridian=Standard_meridian;
inputValues.Local_meridian=Local_meridian;
inputValues.Ground_reflectance=Ground_reflectance;
%PV system data    
inputValues.eta_pv_stc=eta_pv_stc;
inputValues.mu_Voc=mu_Voc;
inputValues.V_mp=V_mp;
inputValues.T_stc=T_stc;
inputValues.NOCT=NOCT;
inputValues.Area_pv=Area_pv;
inputValues.Power_module_pv=Power_module_pv;
%Wind power system data
inputValues.Vc=Vc;
inputValues.Vr=Vr;
inputValues.Vo=Vo;
inputValues.eta_m=eta_m;
inputValues.eta_e=eta_e;
inputValues.C_p=C_p;
inputValues.rho=rho;
%Inverter data
inputValues.eta_inverter=eta_inverter;
                 
inputValues.Control_soc=Control_soc;
inputValues.eta_battery=eta_battery;
inputValues.sigma=sigma;
%Carbon emissions data
inputValues.Carbon_tax=Carbon_tax;
inputValues.Specific_carbon_emissions=Specific_carbon_emissions;

%Electric and thermal load data
inputValues.Electric_load=Electric_load;

%System cost data
inputValues.Specific_cost_pv=Specific_cost_pv;
inputValues.Specific_cost_wind=Specific_cost_wind;
inputValues.Specific_cost_battery=Specific_cost_battery;
inputValues.Specific_cost_inverter=Specific_cost_inverter;
inputValues.Specific_cost_diesel_generator=Specific_cost_diesel_generator;
inputValues.Specific_cost_diesel=Specific_cost_diesel;
inputValues.Specific_cost_grid=Specific_cost_grid;
inputValues.Specific_cost_grid_surplus=Specific_cost_grid_surplus;
inputValues.Project_lifetime=Project_lifetime;
inputValues.pv_lifetime=pv_lifetime;                      
inputValues.wind_lifetime=wind_lifetime;                      
inputValues.battery_lifetime=battery_lifetime;               
inputValues.inverter_lifetime=inverter_lifetime;                  
inputValues.diesel_generator_lifetime=diesel_generator_lifetime;          
inputValues.Tax_rate=Tax_rate;                         
inputValues.Interest_rate=Interest_rate;                     
inputValues.Maintenance_rate_pv=Maintenance_rate_pv;
inputValues.Maintenance_rate_wind=Maintenance_rate_wind;
inputValues.Maintenance_rate_battery=Maintenance_rate_battery;
inputValues.Maintenance_rate_diesel_generator=Maintenance_rate_diesel_generator;
end 
% clearvars -except inputValues;

%% Variables
Tilt_angle=5;            %Degree
Azimuth_angle=0;          %Degree
Power_rated_pv=0;     %W
Tower_height=30;          %m
Power_rated_wind=0;   %W
Battery_capacity=0;   %Wh

%%
%MAIN CODE SOLAR RADIATION 
G_T_R= RadiationCalculation(inputValues,Tilt_angle,Azimuth_angle);

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
