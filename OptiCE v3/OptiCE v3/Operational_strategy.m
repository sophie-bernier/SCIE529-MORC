function [Power_grid,Battery_charged,LCC_battery,Powerbatt]=Operational_strategy(inputValues,Power_tot,Battery_capacity)

Load=inputValues.Electric_load;
eta_inverter=inputValues.eta_inverter;

Specific_cost_battery=inputValues.Specific_cost_battery;
Specific_cost_inverter=inputValues.Specific_cost_inverter;
Project_lifetime=inputValues.Project_lifetime;
battery_lifetime=inputValues.battery_lifetime;  
inverter_lifetime=inputValues.inverter_lifetime; 
Tax_rate=inputValues.Tax_rate;                         
Interest_rate=inputValues.Interest_rate;    
Maintenance_rate_battery=inputValues.Maintenance_rate_battery;

SOC(1)=100;
Powerbatt=zeros(1,8760);
Power_grid=zeros(1,8760);
Loss_Inverter=zeros(1,8760);

for i=1:1:8760;  
    extra_P=(Load (i)-Power_tot(i)*eta_inverter)/eta_inverter;
    if Power_tot(i)*eta_inverter>= Load (i)  % Power surplus
       [SOC(i+1),Powerbatt(i)]=Battery(inputValues,Battery_capacity, SOC(i), extra_P);
       Power_grid(i)=round((Power_tot(i)+Powerbatt(i))*eta_inverter-Load (i),2);
       Loss_Inverter(i)=(Power_tot(i)+Powerbatt(i))*(1-eta_inverter);
    else                                     % Power deficit
       [SOC(i+1),Powerbatt(i)]=Battery(inputValues,Battery_capacity, SOC(i), extra_P);
       Power_grid(i)=round((Power_tot(i)+Powerbatt(i))*eta_inverter-Load (i),2);
       Loss_Inverter(i)=(Power_tot(i)+Powerbatt(i))*(1-eta_inverter);
    end
end

Battery_charged=SOC(1,2:8761)/100*Battery_capacity;

%Initial capital cost
ICC_battery= Specific_cost_battery*Battery_capacity+Specific_cost_inverter*Battery_capacity;

n=1:1:Project_lifetime;

%Tax reduction due to depreciation
d_battery=(ICC_battery-0.1*ICC_battery)/Project_lifetime./((1+Interest_rate).^n)*Tax_rate;  %Assumed to be straight line deprecitaion and salvage value equal to 10% of the ICC
D_battery=sum(d_battery);

%Annual maintenance and operation costs
a_battery=(Maintenance_rate_battery*ICC_battery)./((1+Interest_rate).^n)*(1-Tax_rate);
A_battery=sum(a_battery);

%Replacement costs
r_battery=floor(Project_lifetime/battery_lifetime);
r_inverter=floor(Project_lifetime/inverter_lifetime);
rep_battery=1:1:(r_battery);
rep_inverter=1:1:(r_inverter);

R_battery=sum(Specific_cost_battery*Battery_capacity.*(1/(1+Interest_rate)).^(rep_battery*battery_lifetime)*(1-Tax_rate))...
+sum(Specific_cost_inverter*Battery_capacity.*(1/(1+Interest_rate)).^(rep_inverter*inverter_lifetime)*(1-Tax_rate));

%Salvage value
S_battery=0.1*ICC_battery/((1+Interest_rate)^Project_lifetime);

%Life cycle cost

LCC_battery=ICC_battery+A_battery+R_battery-D_battery-S_battery;