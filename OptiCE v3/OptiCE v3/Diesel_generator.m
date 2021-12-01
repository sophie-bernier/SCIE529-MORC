function [Diesel_rated_power,Diesel_Consumption,LCC_diesel_generator,CO2]=Diesel_generator(inputValues,Power_grid)

Electric_load=inputValues.Electric_load;
Specific_cost_diesel_generator=inputValues.Specific_cost_diesel_generator;
Specific_cost_diesel=inputValues.Specific_cost_diesel;
Project_lifetime=inputValues.Project_lifetime;
diesel_generator_lifetime=inputValues.diesel_generator_lifetime; 
Tax_rate=inputValues.Tax_rate;                         
Interest_rate=inputValues.Interest_rate;    
Maintenance_rate_diesel_generator=inputValues.Maintenance_rate_diesel_generator;

Diesel_rated_power=1.25*max(Electric_load);         
Diesel_Consumption=zeros(size(Power_grid));
ind=find(Power_grid<0);
Diesel_Consumption(ind)=0.246*(-Power_grid(ind)/1000)+0.08145*Diesel_rated_power/1000; %Acoeff=0.246 l/kWh, Bcoeff=0.08145 l/kWh
ind=find(Power_grid>=0);
Diesel_Consumption(ind)=0;
Tot_Diesel_Consumption=sum(Diesel_Consumption);
CO2=Tot_Diesel_Consumption*2.63/1000;  %Tonnes CO2

%Initial capital cost
ICC_diesel_generator= Specific_cost_diesel_generator*Diesel_rated_power;

n=1:1:Project_lifetime;

%Tax reduction due to depreciation
d_diesel_generator=(ICC_diesel_generator-0.1*ICC_diesel_generator)/Project_lifetime./((1+Interest_rate).^n)*Tax_rate;  %Assumed to be straight line deprecitaion and salvage value equal to 10% of the ICC
D_diesel_generator=sum(d_diesel_generator);

%Annual maintenance and operation costs
a_diesel_generator=(Tot_Diesel_Consumption*Specific_cost_diesel)./((1+Interest_rate).^n)*(1-Tax_rate)+(Maintenance_rate_diesel_generator*ICC_diesel_generator)./((1+Interest_rate).^n)*(1-Tax_rate);
A_diesel_generator=sum(a_diesel_generator);

%Replacement costs
r_diesel_generator=floor(Project_lifetime/diesel_generator_lifetime);
rep_Diesel_rated_power=1:1:(r_diesel_generator);

R_diesel_generator=sum(Specific_cost_diesel_generator*Diesel_rated_power.*(1/(1+Interest_rate)).^(rep_Diesel_rated_power*diesel_generator_lifetime)*(1-Tax_rate));

%Salvage value
S_diesel_generator=0.1*ICC_diesel_generator/((1+Interest_rate)^Project_lifetime);

%Life cycle cost

LCC_diesel_generator=ICC_diesel_generator+A_diesel_generator+R_diesel_generator-D_diesel_generator-S_diesel_generator;