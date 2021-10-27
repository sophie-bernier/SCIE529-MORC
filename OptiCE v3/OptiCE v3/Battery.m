function [SOC2,PowerOutput]=Battery(inputValues, Battery_capacity, SOC1, Req_Power)


eta_battery=inputValues.eta_battery;
sigma=inputValues.sigma;
Min_SOC=inputValues.Control_soc*100; % In the input file, the control soc is 0.7; 
Max_SOC=100;
eta=(eta_battery);

if Req_Power<=0 % When the battery charge 
    if SOC1/100*(1-sigma)-Req_Power*eta/Battery_capacity>=(Max_SOC/100)
        SOC2=Max_SOC;
        PowerOutput=-(Max_SOC/100-(SOC1/100*(1-sigma)))*Battery_capacity/eta;
    else
        SOC2=(SOC1/100*(1-sigma)-Req_Power*eta/Battery_capacity)*100;
        PowerOutput=Req_Power;
    end
else % When the battery discharge
    if SOC1/100*(1-sigma)-Req_Power/eta/Battery_capacity<=(Min_SOC/100)
        SOC2=Min_SOC;
        PowerOutput=((SOC1/100*(1-sigma))-Min_SOC/100)*Battery_capacity*eta;
    else
        SOC2=(SOC1/100*(1-sigma)-Req_Power/eta/Battery_capacity)*100;
        PowerOutput=Req_Power;
    end
end





    