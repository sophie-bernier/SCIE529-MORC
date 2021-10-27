function [Power_pv,LCC_pv]=Power_lcc_pv(inputValues,Power_rated_pv,G_T_R)

Ambient_temperature=inputValues.Ambient_temperature;
Wind_speed=inputValues.Wind_speed;
eta_pv_stc=inputValues.eta_pv_stc;
mu_Voc=inputValues.mu_Voc;
V_mp=inputValues.V_mp;
T_stc=inputValues.T_stc;
NOCT=inputValues.NOCT;
Area_pv=inputValues.Area_pv;
Power_module_pv=inputValues.Power_module_pv;

Specific_cost_pv=inputValues.Specific_cost_pv;
Specific_cost_inverter=inputValues.Specific_cost_inverter;
Project_lifetime=inputValues.Project_lifetime;
pv_lifetime=inputValues.pv_lifetime;  
inverter_lifetime=inputValues.inverter_lifetime; 
Tax_rate=inputValues.Tax_rate;                         
Interest_rate=inputValues.Interest_rate;    
Maintenance_rate_pv=inputValues.Maintenance_rate_pv;

mu=eta_pv_stc*mu_Voc/V_mp;

eta_pv=eta_pv_stc.*(1+mu/eta_pv_stc.*(Ambient_temperature-T_stc)+mu/eta_pv_stc.*(NOCT-20)/800*9.5./(5.7+3.8.*Wind_speed)*(1-eta_pv_stc).*G_T_R);

Power_pv=(Power_rated_pv/1000./eta_pv_stc).*eta_pv.*G_T_R;

%Initial capital cost
ICC_pv= Specific_cost_pv*Power_rated_pv+Specific_cost_inverter*Power_rated_pv;

n=1:1:Project_lifetime;

%Tax reduction due to depreciation
d_pv=(ICC_pv-0.1*ICC_pv)/Project_lifetime./((1+Interest_rate).^n)*Tax_rate;  %Assumed to be straight line deprecitaion and salvage value equal to 10% of the ICC
D_pv=sum(d_pv);

%Annual maintenance and operation costs
a_pv=(Maintenance_rate_pv*ICC_pv)./((1+Interest_rate).^n)*(1-Tax_rate);
A_pv=sum(a_pv);

%Replacement costs
r_pv=floor(Project_lifetime/pv_lifetime)-1;  %To avoid replacement of the PV system at the end of the project lifetime assumed equal to the PV lifetime
r_inverter=floor(Project_lifetime/inverter_lifetime);
rep_pv=1:1:(r_pv);
rep_inverter=1:1:(r_inverter);

R_pv=sum(Specific_cost_pv*Power_rated_pv.*(1/(1+Interest_rate)).^(rep_pv*pv_lifetime)*(1-Tax_rate))...
+sum(Specific_cost_inverter*Power_rated_pv.*(1/(1+Interest_rate)).^(rep_inverter*inverter_lifetime)*(1-Tax_rate));

%Salvage value
S_pv=0.1*ICC_pv/((1+Interest_rate)^Project_lifetime);

%Life cycle cost

LCC_pv=ICC_pv+A_pv+R_pv-D_pv-S_pv;
