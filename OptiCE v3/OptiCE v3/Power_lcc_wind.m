function [Power_wind,LCC_wind]=Power_lcc_wind(inputValues,Power_rated_wind,Tower_height)

Wind_speed=inputValues.Wind_speed;
Vc=inputValues.Vc;
Vr=inputValues.Vr;
Vo=inputValues.Vo;
eta_m=inputValues.eta_m;
eta_e=inputValues.eta_e;
C_p=inputValues.C_p;
rho=inputValues.rho;
eta_inverter=inputValues.eta_inverter;

Specific_cost_wind=inputValues.Specific_cost_wind;
Specific_cost_inverter=inputValues.Specific_cost_inverter;
Project_lifetime=inputValues.Project_lifetime;
wind_lifetime=inputValues.wind_lifetime;  
inverter_lifetime=inputValues.inverter_lifetime; 
Tax_rate=inputValues.Tax_rate;                         
Interest_rate=inputValues.Interest_rate;    
Maintenance_rate_wind=inputValues.Maintenance_rate_wind;

Wind_tower=Wind_speed*(Tower_height/10).^0.11;
A_swept=2*Power_rated_wind/(eta_m*eta_e*rho*C_p*Vr^3);
Power_wind=zeros(size(Wind_speed));

ind=find(Wind_tower<=Vc);
Power_wind(ind)=0;
ind=find(Wind_tower<=Vr & Wind_tower>Vc);
Power_wind(ind)=1/2*C_p*rho*eta_m*A_swept*Wind_tower(ind).^3;
ind=find(Wind_tower<Vo & Wind_tower>Vr);
Power_wind(ind)=Power_rated_wind;
ind=find(Wind_tower>=Vo);
Power_wind(ind)=0;

%Initial capital cost
ICC_wind= Specific_cost_wind*Power_rated_wind+Specific_cost_inverter*Power_rated_wind;

n=1:1:Project_lifetime;

%Tax reduction due to depreciation
d_wind=(ICC_wind-0.1*ICC_wind)/Project_lifetime./((1+Interest_rate).^n)*Tax_rate;  %Assumed to be straight line deprecitaion and salvage value equal to 10% of the ICC
D_wind=sum(d_wind);

%Annual maintenance and operation costs
a_wind=(Maintenance_rate_wind*ICC_wind)./((1+Interest_rate).^n)*(1-Tax_rate);
A_wind=sum(a_wind);

%Replacement costs
r_wind=floor(Project_lifetime/wind_lifetime);
r_inverter=floor(Project_lifetime/inverter_lifetime);
rep_wind=1:1:(r_wind);
rep_inverter=1:1:(r_inverter);

R_wind=sum(Specific_cost_wind*Power_rated_wind.*(1/(1+Interest_rate)).^(rep_wind*wind_lifetime)*(1-Tax_rate))...
+sum(Specific_cost_inverter*Power_rated_wind.*(1/(1+Interest_rate)).^(rep_inverter*inverter_lifetime)*(1-Tax_rate));

%Salvage value
S_wind=0.1*ICC_wind/((1+Interest_rate)^Project_lifetime);

%Life cycle cost

LCC_wind=ICC_wind+A_wind+R_wind-D_wind-S_wind;